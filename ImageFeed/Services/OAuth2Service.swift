//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 04/07/26.
//

import Foundation

final class OAuth2Service {

    // MARK: - Singleton

    static let shared = OAuth2Service()

    // MARK: - Private Properties

    private let tokenStorage = OAuth2TokenStorage()

    private init() {}

    // MARK: - Public Methods

    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[OAuth2Service]: invalidRequest")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self?.tokenStorage.token = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                } catch {
                    print("[OAuth2Service]: decodingError - \(error)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                print("[OAuth2Service]: networkError - \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: - Private Methods

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
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
            return nil
        }

        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
}
