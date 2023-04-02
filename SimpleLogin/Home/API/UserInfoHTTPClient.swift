//
//  UserInfoHTTPClient.swift
//  SimpleLogin
//
//  Created by Reynaldi on 03/04/23.
//

import Foundation

protocol UserInfoHTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
