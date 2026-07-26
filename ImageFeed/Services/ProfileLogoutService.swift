//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 24/07/26.
//

import Foundation
import WebKit

final class ProfileLogoutService {

    // MARK: - Singleton

    static let shared = ProfileLogoutService()

    private init() {}

    // MARK: - Public Methods

    func logout() {
        OAuth2TokenStorage.shared.token = nil
        ProfileService.shared.reset()
        ProfileImageService.shared.reset()
        ImagesListService.shared.reset()
        cleanCookies()
    }

    // MARK: - Private Methods

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
