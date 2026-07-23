//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 04/07/26.
//

import UIKit
import WebKit

// MARK: - Constants

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let progressTintColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
}

// MARK: - WebViewViewControllerDelegate

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {

    // MARK: - Private Properties

    private var estimatedProgressObservation: NSKeyValueObservation?

    // MARK: - Subviews

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = WebViewConstants.progressTintColor
        return progressView
    }()

    // MARK: - Public Properties

    weak var delegate: WebViewViewControllerDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()

        webView.navigationDelegate = self

        loadAuthView()

        updateProgress()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
            changeHandler: { [weak self] _, _ in
                guard let self else { return }
                self.updateProgress()
            }
        )
        updateProgress()
    }

    // MARK: - Private Methods

    private func setupView() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: webView.bottomAnchor),

            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: progressView.trailingAnchor)
        ])
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }

    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("[WebViewViewController.loadAuthView]: failed to create URLComponents from \(WebViewConstants.unsplashAuthorizeURLString)")
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]

        guard let url = urlComponents.url else {
            print("[WebViewViewController.loadAuthView]: failed to create URL from urlComponents")
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
