//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 04/07/26.
//

import Foundation

final class OAuth2TokenStorage {

    private let userDefaults = UserDefaults.standard

    var token: String? {
        get {
            userDefaults.string(forKey: "token")
        }
        set {
            userDefaults.set(newValue, forKey: "token")
        }
    }
}
