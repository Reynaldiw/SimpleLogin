//
//  URLSessionUserInfoClient.swift
//  SimpleLogin
//
//  Created by Reynaldi on 03/04/23.
//

import Foundation

final class URLSessionUserInfoClient: UserInfoHTTPClient {
    
    private struct UnExpectedValuesRepresentation: Error {}
    
    func get(from url: URL, completion: @escaping (UserInfoHTTPClient.Result) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let urlResponse = urlResponse as? HTTPURLResponse {
                    return (data, urlResponse)
                } else {
                    throw UnExpectedValuesRepresentation()
                }
            })
        }
        task.resume()
    }
}
