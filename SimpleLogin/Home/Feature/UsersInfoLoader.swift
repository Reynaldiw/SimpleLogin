//
//  UsersInfoLoader.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import Foundation

protocol UserInfoLoader {
    typealias Result = Swift.Result<[UserInfo], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
