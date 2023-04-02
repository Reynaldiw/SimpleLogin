//
//  LoginViewController.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let loginView: LoginView = .init(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
    }
    
    private func configureNavigationBar() {
        title = "Login Page"
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginView.heightAnchor.constraint(equalToConstant: 152)
        ])
    }
}
