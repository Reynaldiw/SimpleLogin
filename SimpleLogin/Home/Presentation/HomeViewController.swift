//
//  HomeViewController.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import UIKit

final class HomeViewController: UITableViewController {
    
    private var usersInfo = [UserInfo]()
    
    private let client: UserInfoHTTPClient = URLSessionUserInfoClient()
    private let imageDownloader: ImageDownloader = URLSessionImageDownloaderClient()
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
        
        if let url = model.avatarImageURL {
            downloadImage(from: url, to: cell)
        } else {
            cell.configureImage(with: nil)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    private func downloadImage(from url: URL, to cell: UserInfoCell) {
        imageDownloader.download(from: url) { [weak self] data in
            guard self != nil else { return }
            
            DispatchQueue.main.async {
                cell.configureImage(with: data)
            }
        }
    }
}

private extension UserInfoCell {
    func configureView(with model: UserInfo) {
        configureView()
        
        nameLabel.text = "\(model.firstName) \(model.lastName)"
        emailLabel.text = model.email
    }
    
    func configureImage(with data: Data?) {
        guard let data = data else {
            return avatarImageView.backgroundColor = .gray
        }
        avatarImageView.image = UIImage(data: data)
    }
}

private extension UserInfo {
    static var prototypeData: [UserInfo] {
        let model = UserInfo(id: 7, avatarImageURL: URL(string: "https://reqres.in/img/faces/7-image.jpg"), email: "michael.lawson@reqres.in", firstName: "Michael", lastName: "Lawson")
        
        return [model, model, model]
    }
}
