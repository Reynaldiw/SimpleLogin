//
//  LoginHTTPClient.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import Foundation

protocol LoginHTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func login(from url: URL, with request: [String: Any], completion: @escaping (Result) -> Void)
}
