//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 11/06/26.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {

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
        static let loginColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
    }

    // MARK: - Public Properties

    var presenter: ProfilePresenterProtocol?

    // MARK: - Private Properties

    private var profileImageServiceObserver: NSObjectProtocol?

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .avatar))
        imageView.layer.cornerRadius = Constants.avatarCornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(resource: .logoutButton), for: .normal)
        button.accessibilityIdentifier = "logout button"
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

        view.backgroundColor = UIColor(resource: .ypBlack)
        setupConstraints()

        presenter?.viewDidLoad()

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }

    // MARK: - Actions

    @objc private func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            self?.presenter?.didTapLogout()
            self?.switchToSplash()
        })
        present(alert, animated: true)
    }

    // MARK: - Public Methods

    func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name.isEmpty
            ? "Имя не указано"
            : profile.name
        loginNameLabel.text = profile.loginName.isEmpty
            ? "@неизвестный_пользователь"
            : profile.loginName
        descriptionLabel.text = (profile.bio?.isEmpty ?? true)
            ? "Профиль не заполнен"
            : profile.bio
    }

    func cleanAvatarAndLabels() {
        nameLabel.text = nil
        loginNameLabel.text = nil
        descriptionLabel.text = nil
        avatarImageView.image = UIImage(resource: .avatar)
    }

    // MARK: - Private Methods

    private func switchToSplash() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        else { return }
        window.rootViewController = SplashViewController()
    }

    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }

        let processor = RoundCornerImageProcessor(cornerRadius: Constants.avatarCornerRadius)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(resource: .avatar),
            options: [.processor(processor)]
        )
    }

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
