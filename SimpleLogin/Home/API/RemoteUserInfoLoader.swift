//
//  RemoteUserInfoLoader.swift
//  SimpleLogin
//
//  Created by Reynaldi on 03/04/23.
//

import Foundation

protocol UserInfoHTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

final class RemoteUserInfoLoader: UserInfoLoader {
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
        case serverFailure
    }
    
    typealias Result = UserInfoLoader.Result
    
    private let url: URL
    private let client: UserInfoHTTPClient
    
    init(url: URL, client: UserInfoHTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (UserInfoLoader.Result) -> Void) {
        client.get(from: url) { [weak self] receivedResult in
            guard self != nil else { return }
            
            switch receivedResult {
            case let .success((data, response)):
                completion(RemoteUserInfoLoader.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let rootModel = try UserInfoMapper.map(data, from: response)
            return .success(rootModel.toModels())
            
        } catch {
            return .failure(error)
        }
    }
}

private extension Collection where Element == RemoteUserInfo {
    func toModels() -> [UserInfo] {
        return map { .init(id: $0.id, avatarImageURL: URL(string: $0.avatarImageURL), email: $0.email, firstName: $0.firstName, lastName: $0.lastName) }
    }
}

final class UserInfoMapper {
    private struct Root {
        let data: [RemoteUserInfo]
        
        init(_ jsonValues: [String: Any]) {
            var userInfoItems = [RemoteUserInfo]()
            let dataJsonValues = jsonValues["data"] as? [[String: Any]] ?? []
            dataJsonValues.forEach { jsonItemValue in
                userInfoItems.append(RemoteUserInfo(jsonItemValue))
            }
            
            self.data = userInfoItems
        }
    }
    
    private static var OK_RESPONSE: Int {
        return 200
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteUserInfo] {
        guard response.statusCode == OK_RESPONSE else {
            throw RemoteUserInfoLoader.Error.serverFailure
        }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw RemoteUserInfoLoader.Error.invalidData
            }
            
            return Root(json).data
            
        } catch {
            throw RemoteUserInfoLoader.Error.invalidData
        }
    }
}

internal struct RemoteUserInfo {
    let id: Int
    let avatarImageURL: String
    let email: String
    let firstName: String
    let lastName: String
    
    init(_ jsonValues: [String: Any]) {
        self.id = jsonValues["id"] as? Int ?? 0
        self.avatarImageURL = jsonValues["avatar"] as? String ?? ""
        self.email = jsonValues["email"] as? String ?? ""
        self.firstName = jsonValues["first_name"] as? String ?? ""
        self.lastName = jsonValues["last_name"] as? String ?? ""
    }
}
