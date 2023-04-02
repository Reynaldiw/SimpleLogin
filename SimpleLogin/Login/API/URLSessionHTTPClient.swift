//
//  URLSessionHTTPClient.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import Foundation

final class URLSessionHTTPClient: LoginHTTPClient {
    
    private struct UnExpectedValuesRepresentation: Error {}
    
    func login(from url: URL, with request: [String : Any], completion: @escaping (LoginHTTPClient.Result) -> Void) {
        let urlRequest = URLSessionHTTPClient.createURLRequest(url, with: request)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
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
    
    private static func createURLRequest(_ url: URL, with request: [String: Any]) -> URLRequest {
        let requestBodyData = try? JSONSerialization.data(withJSONObject: request)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBodyData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
}
