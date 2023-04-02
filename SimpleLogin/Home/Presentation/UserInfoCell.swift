//
//  UserInfoCell.swift
//  SimpleLogin
//
//  Created by Reynaldi on 03/04/23.
//

import UIKit

final class UserInfoCell: UITableViewCell {
    
    public let contentContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public let avatarImageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    public let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public let contentTextContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    public let emailContainerView = UIView()
    
    public let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public func configureView() {
        addSubview(contentContainerStackView)
        contentContainerStackView.addArrangedSubview(avatarImageContainerView)
        avatarImageContainerView.addSubview(avatarImageView)
        contentContainerStackView.addArrangedSubview(contentTextContainerStackView)
        contentTextContainerStackView.addArrangedSubview(nameLabel)
        contentTextContainerStackView.addArrangedSubview(emailContainerView)
        emailContainerView.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            contentContainerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            contentContainerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            contentContainerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            contentContainerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
        
        configureAvatarImageView()
        configureEmailComponent()
    }
    
    private func configureAvatarImageView() {
        NSLayoutConstraint.activate([
            avatarImageContainerView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: avatarImageContainerView.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: avatarImageContainerView.trailingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: avatarImageContainerView.topAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        avatarImageView.layer.cornerRadius = 12
        avatarImageView.clipsToBounds = true
    }
    
    private func configureEmailComponent() {
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor),
            emailLabel.topAnchor.constraint(equalTo: emailContainerView.topAnchor),
        ])
    }
}
