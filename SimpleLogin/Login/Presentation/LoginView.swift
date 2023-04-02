//
//  LoginView.swift
//  SimpleLogin
//
//  Created by Reynaldi on 02/04/23.
//

import UIKit

final class LoginView: UIView {
    
    public var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public var emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .black
        return textField
    }()
    
    public var passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .black
        return textField
    }()
    
    public var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.backgroundColor = .red
        return button
    }()
    
    private var componentCornerRadius: CGFloat {
        return 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureView()
    }
    
    private func configureView() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(emailField)
        contentStackView.addArrangedSubview(passwordField)
        contentStackView.addArrangedSubview(loginButton)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: self.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        configureTextField()
        configureButton()
    }
    
    private func configureTextField() {
        [emailField, passwordField].forEach { field in
            field.applyHorizontalPadding(10)
            field.layer.cornerRadius = componentCornerRadius
            field.layer.masksToBounds = true
            field.clipsToBounds = true
            field.applyBorder()
        }
    }
    
    private func configureButton() {
        loginButton.layer.cornerRadius = componentCornerRadius
        loginButton.layer.masksToBounds = true
        loginButton.clipsToBounds = true
    }
}

private extension UITextField {
    func applyBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
    }
    
    func applyHorizontalPadding(_ spacing: CGFloat) {
        let widthValue = spacing
        let spacingView = UIView(frame: CGRect(x: 0, y: 0, width: widthValue, height: frame.size.height))
        
        leftView = spacingView
        leftViewMode = .always
        
        rightView = spacingView
        rightViewMode = .always
    }
}
