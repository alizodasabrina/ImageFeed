//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 11/06/26.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let avatarSize: CGFloat = 70
        static let avatarCornerRadius: CGFloat = 35
        static let logoutButtonSize: CGFloat = 44
        static let horizontalInset: CGFloat = 16
        static let topInset: CGFloat = 32
        static let verticalSpacing: CGFloat = 8
        static let nameFontSize: CGFloat = 23
        static let secondaryFontSize: CGFloat = 13
        static let backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        static let loginColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
    }

    // MARK: - Private Properties

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "avatar"))
        imageView.layer.cornerRadius = Constants.avatarCornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = .systemFont(ofSize: Constants.nameFontSize, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = .systemFont(ofSize: Constants.secondaryFontSize)
        label.textColor = Constants.loginColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.font = .systemFont(ofSize: Constants.secondaryFontSize)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.backgroundColor
        setupConstraints()
    }

    // MARK: - Actions

    @objc private func didTapLogoutButton() {
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        view.addSubview(avatarImageView)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topInset),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalInset),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarSize),

            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalInset),
            logoutButton.widthAnchor.constraint(equalToConstant: Constants.logoutButtonSize),
            logoutButton.heightAnchor.constraint(equalToConstant: Constants.logoutButtonSize),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.verticalSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalInset),

            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.verticalSpacing),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: Constants.verticalSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
}
