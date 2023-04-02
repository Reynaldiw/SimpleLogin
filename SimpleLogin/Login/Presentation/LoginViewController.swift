//
//  LoginViewController.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let loginView: LoginView = .init(frame: .zero)
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
    }
    
    private func configureNavigationBar() {
        title = "Login"
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
        
        loginView.loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
}


//MARK: - Action

extension LoginViewController {
    @objc private func loginAction() {
        login()
    }
}

extension LoginViewController {
    private func login() {
        let request: [String: Any] = [
            "email": loginView.emailField.text ?? "",
            "password": loginView.passwordField.text ?? ""
        ]
        loginService.login(with: request) { [weak self] receivedResult in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch receivedResult {
                case .success:
                    let homeViewController = HomeViewControllerComposer.compose()
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    
                case let .failure(error):
                    self.map(error)
                }
            }
        }
    }
    
    private func map(_ error: Error) {
        switch error as? LoginValidationUseCase.Error {
        case .emailEmpty, .passwordEmpty:
            presentAlert(message: "Please input all required field")
            
        case .invalidEmail:
            presentAlert(message: "Invalid email")
            
        default:
            presentAlert(title: "Failed", message: "Something went wrong!")
        }
    }
    
    private func presentAlert(title: String = "Warning", message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        navigationController?.present(alertViewController, animated: true)
    }
}

