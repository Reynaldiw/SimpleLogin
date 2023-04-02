//
//  LoginService.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import Foundation

protocol LoginService {
    typealias Result = Swift.Result<LoginMessage, Error>
    
    func login(with request: [String: Any], completion: @escaping (Result) -> Void)
}
