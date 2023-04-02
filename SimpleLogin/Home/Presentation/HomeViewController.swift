//
//  HomeViewController.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import UIKit

final class URLSessionDownloaderClient: ImageDownloader {
    func download(from url: URL, completion: @escaping (ImageDownloader.Result) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            completion(data)
        }.resume()
    }
}



final class HomeViewController: UITableViewController {
    
    private var usersInfo = [UserInfo]()
    
    private let client: UserInfoHTTPClient = URLSessionUserInfoClient()
    private let imageDownloader: ImageDownloader = URLSessionDownloaderClient()
    private let url: URL = URL(string: "https://reqres.in/api/users?page=2")!
    private var loader: UserInfoLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        
        loader = RemoteUserInfoLoader(url: url, client: client)
        loadUsers()
    }
    
    private func loadUsers() {
        loader.load { [weak self] receivedResult in
            guard let self = self else { return }
            
            if let models = (try? receivedResult.get()) {
                self.usersInfo = models
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = usersInfo[indexPath.row]
        let cell = UserInfoCell()
        cell.configureView(with: model)
        
        if let imageURL = model.avatarImageURL {
            imageDownloader.download(from: imageURL) { [weak self] data in
                guard self != nil else { return }
                
                DispatchQueue.main.async {
                    if let imageData = data {
                        cell.avatarImageView.image = UIImage(data: imageData)
                    } else {
                        cell.avatarImageView.backgroundColor = .gray
                    }
                }
            }
        } else {
            cell.avatarImageView.backgroundColor = .gray
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}

private extension UserInfoCell {
    func configureView(with model: UserInfo) {
        configureView()
        
        nameLabel.text = "\(model.firstName) \(model.lastName)"
        emailLabel.text = model.email
    }
}

private extension UserInfo {
    static var prototypeData: [UserInfo] {
        let model = UserInfo(id: 7, avatarImageURL: URL(string: "https://reqres.in/img/faces/7-image.jpg"), email: "michael.lawson@reqres.in", firstName: "Michael", lastName: "Lawson")
        
        return [model, model, model]
    }
}
