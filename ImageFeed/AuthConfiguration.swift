//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 04/07/26.
//

import Foundation

// MARK: - Constants

enum Constants {
    static let accessKey = "Xwgbxb2UcoCOigMN3tmnTNA-WmWrbwUn9E0StCP4lpI"
    static let secretKey = "iH8dHpP8JnmmPlV5QCG2b0NgWyHhh385zjUyuV8cggM"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"

    static let defaultBaseURLString = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
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
