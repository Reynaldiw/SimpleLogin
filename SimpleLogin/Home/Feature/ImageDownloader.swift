//
//  ImageDownloader.swift
//  SimpleLogin
//
//  Created by Reynaldi on 03/04/23.
//

import Foundation

protocol ImageDownloader {
    typealias Result = Data?
    
    func download(from url: URL, completion: @escaping (Result) -> Void)
}
