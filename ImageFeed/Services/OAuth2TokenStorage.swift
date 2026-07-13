//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 04/07/26.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {

    // MARK: - Singleton

    static let shared = OAuth2TokenStorage()

    private init() {}

    // MARK: - Private Properties

    private let tokenKey = "token"

    // MARK: - Public Properties

    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
