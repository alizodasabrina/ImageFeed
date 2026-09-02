//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 04/07/26.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {

    // MARK: - Constants

    private let showWebViewSegueIdentifier = "ShowWebView"

    private enum Constants {
        static let logoSize: CGFloat = 60
        static let buttonHeight: CGFloat = 48
        static let buttonSideInset: CGFloat = 16
        static let buttonBottomInset: CGFloat = 90
        static let buttonCornerRadius: CGFloat = 16
        static let buttonFontSize: CGFloat = 17
        static let backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
    }

    // MARK: - Public Properties

    weak var delegate: AuthViewControllerDelegate?

    // MARK: - Private Properties

    private let oauth2Service = OAuth2Service.shared

    // MARK: - Subviews

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .authScreenLogo))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: Constants.buttonFontSize)
        button.tintColor = UIColor(resource: .ypBlack)
        button.backgroundColor = .white
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.accessibilityIdentifier = "authenticate button"
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        configureBackButton()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    // MARK: - Actions

    @objc private func didTapLoginButton() {
        performSegue(withIdentifier: showWebViewSegueIdentifier, sender: nil)
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(logoImageView)
        view.addSubview(loginButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.logoSize),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            loginButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.buttonSideInset),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: Constants.buttonSideInset),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Constants.buttonBottomInset)
        ])
    }

    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .navBackButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .navBackButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(resource: .ypBlack)
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)

        UIBlockingProgressHUD.show()

        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self else { return }
            switch result {
            case .success:
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("[AuthViewController]: fetchAuthToken error - \(error)")
                self.showAuthErrorAlert()
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }

    private func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}
