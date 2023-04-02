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

extension RemoteLoginMessage {
    func toModel() -> LoginMessage {
        return .init(token: token)
    }
}
