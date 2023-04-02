//
//  URLSessionImageDownloaderClient.swift
//  SimpleLogin
//
//  Created by Reynaldi on 03/04/23.
//

import Foundation


final class URLSessionImageDownloaderClient: ImageDownloader {
    func download(from url: URL, completion: @escaping (ImageDownloader.Result) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            completion(data)
        }.resume()
    }
}
