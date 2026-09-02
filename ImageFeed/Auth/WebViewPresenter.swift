//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 28/08/26.
//

import Foundation

// MARK: - WebViewPresenterProtocol

protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

// MARK: - WebViewPresenter

final class WebViewPresenter: WebViewPresenterProtocol {

    // MARK: - Public Properties

    weak var view: WebViewViewControllerProtocol?
    private let authHelper: AuthHelperProtocol

    // MARK: - Init

    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    // MARK: - Public Methods

    func viewDidLoad() {
        guard let request = authHelper.authRequest() else {
            print("[WebViewPresenter.viewDidLoad]: failed to create auth request")
            return
        }

        view?.load(request: request)
        didUpdateProgressValue(0)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
