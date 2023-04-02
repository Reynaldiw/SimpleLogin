//
//  LoginViewControllerComposer.swift
//  SimpleLogin
//
//  Created by Reynaldi on 03/04/23.
//

import Foundation

final class LoginViewControllerComposer {
    static func compose() -> LoginViewController {
        let url = URL(string: "https://reqres.in/api/login")!
        let client: LoginHTTPClient = URLSessionHTTPClient()
        let service: LoginService = LoginValidationUseCase(url: url, client: client)
        
        return LoginViewController(loginService: service)
    }
}
