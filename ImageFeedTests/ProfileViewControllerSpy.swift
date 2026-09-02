//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Sabrina Mavlyanova on 29/08/26.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?

    var updateProfileDetailsCalled: Bool = false
    var cleanAvatarAndLabelsCalled: Bool = false

    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsCalled = true
    }

    func cleanAvatarAndLabels() {
        cleanAvatarAndLabelsCalled = true
    }
}
