//
//  HomeViewController.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import UIKit

final class HomeViewController: UITableViewController {
    
    private var usersInfo = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        
        loadUsers()
    }
    
    private func loadUsers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.usersInfo = UserInfo.prototypeData
            self.tableView.reloadData()
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
