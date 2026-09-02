//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Sabrina Mavlyanova on 29/08/26.
//

@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var didTapLogoutCalled: Bool = false
    var view: ProfileViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didTapLogout() {
        didTapLogoutCalled = true
    }

    func updateProfile() {}
}
