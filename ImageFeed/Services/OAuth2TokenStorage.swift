//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 04/07/26.
//

import Foundation

final class OAuth2TokenStorage {

    // MARK: - Constants

    private enum Keys: String {
        case token
    }

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard

    // MARK: - Public Properties

    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
