//
//  HomeViewControllerComposer.swift
//  SimpleLogin
//
//  Created by Reynaldi on 03/04/23.
//

import Foundation

final class HomeViewControllerComposer {
    static func compose() -> HomeViewController {
        let url = URL(string: "https://reqres.in/api/users?page=2")!
        let client: UserInfoHTTPClient = URLSessionUserInfoClient()
        let loader: UserInfoLoader = RemoteUserInfoLoader(url: url, client: client)
        let downloader: ImageDownloader = URLSessionImageDownloaderClient()
        
        return HomeViewController(imageDownloader: downloader, loader: loader)
    }
}
