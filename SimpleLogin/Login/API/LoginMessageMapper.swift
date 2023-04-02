//
//  LoginMessageMapper.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import Foundation

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
