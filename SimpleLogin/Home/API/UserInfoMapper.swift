//
//  UserInfoMapper.swift
//  SimpleLogin
//
//  Created by Reynaldi on 03/04/23.
//

import Foundation

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
