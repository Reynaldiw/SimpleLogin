//
//  RemoteLoginMessage.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import Foundation

internal struct RemoteLoginMessage {
    internal let token: String
    
    init(_ values: [String: Any]) {
        self.token = values["token"] as? String ?? ""
    }
}
