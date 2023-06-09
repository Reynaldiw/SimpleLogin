//
//  LoginRequestPolicy.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import Foundation

final class LoginRequestPolicy {
    
    enum Error: Swift.Error {
        case emailEmpty
        case invalidEmail
        case passwordEmpty
    }
    
    static func validate(_ request: [String: Any]) throws {
        guard let email = request["email"] as? String else { throw Error.emailEmpty }
        guard let password = request["password"] as? String, !password.isEmpty else { throw Error.passwordEmpty }
        
        try validate(email)
    }
    
    private static func validate(_ email: String) throws {
        guard !email.isEmpty else { throw Error.emailEmpty }
        guard email.isValidEmail else { throw Error.invalidEmail }
    }
}

private extension String {
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
}

