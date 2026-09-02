//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 29/08/26.
//

import Foundation

// MARK: - ProfileViewControllerProtocol

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile)
    func cleanAvatarAndLabels()
}

// MARK: - ProfilePresenterProtocol

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogout()
    func updateProfile()
}

// MARK: - ProfilePresenter

final class ProfilePresenter: ProfilePresenterProtocol {

    // MARK: - Public Properties

    weak var view: ProfileViewControllerProtocol?

    // MARK: - Public Methods

    func viewDidLoad() {
        updateProfile()
    }

    func updateProfile() {
        guard let profile = ProfileService.shared.profile else { return }
        view?.updateProfileDetails(profile: profile)
    }

    func didTapLogout() {
        ProfileLogoutService.shared.logout()
        view?.cleanAvatarAndLabels()
    }
}
