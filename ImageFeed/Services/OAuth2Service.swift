//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 04/07/26.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {

    // MARK: - Singleton

    static let shared = OAuth2Service()

    // MARK: - Private Properties

    private let tokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private var lastCode: String?

    private init() {}

    // MARK: - Public Methods

    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }

        task?.cancel()
        lastCode = code

        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[OAuth2Service.fetchAuthToken]: invalidRequest")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            switch result {
            case .success(let responseBody):
                self.tokenStorage.token = responseBody.accessToken
                completion(.success(responseBody.accessToken))
            case .failure(let error):
                print("[OAuth2Service.fetchAuthToken]: \(error)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }

    // MARK: - Private Methods

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("[OAuth2Service.makeOAuthTokenRequest]: failed to create URLComponents")
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        guard let authTokenUrl = urlComponents.url else {
            print("[OAuth2Service.makeOAuthTokenRequest]: failed to create URL from urlComponents")
            return nil
        }

        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
}
