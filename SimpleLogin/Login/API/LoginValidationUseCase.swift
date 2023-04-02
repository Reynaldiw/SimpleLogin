//
//  LoginValidationUseCase.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import Foundation

final class LoginValidationUseCase: LoginService {
    
    enum Error: Swift.Error {
        case emailEmpty
        case invalidEmail
        case passwordEmpty
        case loginFailed
        case invalidData
    }
    
    typealias Result = LoginService.Result
    
    private let url: URL
    private let client: LoginHTTPClient
    
    init(url: URL, client: LoginHTTPClient) {
        self.url = url
        self.client = client
    }
    
    func login(with request: [String : Any], completion: @escaping (LoginService.Result) -> Void) {
        do {
            try LoginRequestPolicy.validate(request)
        } catch {
            return completion(.failure(LoginValidationUseCase.map(error as! LoginRequestPolicy.Error)))
        }
        
        client.login(from: url, with: request) { receivedResult in
            switch receivedResult {
            case let .success((data, response)):
                completion(LoginValidationUseCase.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.loginFailed))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let rootModel = try LoginMessageMapper.map(data, from: response)
            return .success(rootModel.toModel())
            
        } catch {
            return .failure(error)
        }
    }
    
    private static func map(_ error: LoginRequestPolicy.Error) -> Error {
        switch error {
        case .emailEmpty:
            return .emailEmpty
            
        case .invalidEmail:
            return .invalidEmail
            
        case .passwordEmpty:
            return .passwordEmpty
        }
    }
}

internal struct RemoteLoginMessage {
    internal let token: String
    
    init(_ values: [String: Any]) {
        self.token = values["token"] as? String ?? ""
    }
}

extension RemoteLoginMessage {
    func toModel() -> LoginMessage {
        return .init(token: token)
    }
}

final class LoginMessageMapper {
    
    private static var OK_RESPONSE: Int {
        return 200
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteLoginMessage {
        guard response.statusCode == OK_RESPONSE else {
            throw LoginValidationUseCase.Error.loginFailed
        }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw LoginValidationUseCase.Error.invalidData
            }
            
            return RemoteLoginMessage(json)
            
        } catch {
            throw LoginValidationUseCase.Error.invalidData
        }
    }
}

final class LoginRequestPolicy {
    
    enum Error: Swift.Error {
        case emailEmpty
        case invalidEmail
        case passwordEmpty
    }
    
    static func validate(_ request: [String: Any]) throws {
        guard let email = request["email"] as? String else { throw Error.emailEmpty }        
        guard let password = request["password"] as? String, !password.isEmpty else { throw Error.passwordEmpty }
        
        try validate(email)
    }
    
    private static func validate(_ email: String) throws {
        guard !email.isEmpty else { throw Error.emailEmpty }
        guard email.isValidEmail else { throw Error.invalidEmail }
    }
    
}

private extension String {
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
}
