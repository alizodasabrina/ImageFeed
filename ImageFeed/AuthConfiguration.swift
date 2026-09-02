//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 04/07/26.
//

import Foundation

// MARK: - Constants

enum Constants {
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"

    static let defaultBaseURLString = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

    static var accessKey: String {
        Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_ACCESS_KEY") as? String ?? ""
    }

    static var secretKey: String {
        Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_SECRET_KEY") as? String ?? ""
    }
}

// MARK: - AuthConfiguration

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String

    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURLString: Constants.defaultBaseURLString,
                                 authURLString: Constants.unsplashAuthorizeURLString)
    }
}
