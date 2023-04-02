//
//  RemoteUserInfo.swift
//  SimpleLogin
//
//  Created by Reynaldi on 03/04/23.
//

import Foundation

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
