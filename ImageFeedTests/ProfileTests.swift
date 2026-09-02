//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Sabrina Mavlyanova on 29/08/26.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {

    // MARK: - Properties

    private var viewControllerSpy: ProfileViewControllerSpy?
    private var presenter: ProfilePresenter?

    override func tearDown() {
        viewControllerSpy = nil
        presenter = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }

    func testPresenterUpdatesProfileDetails() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        self.viewControllerSpy = viewController
        self.presenter = presenter

        //when
        presenter.updateProfile()

        //then
        if ProfileService.shared.profile != nil {
            XCTAssertTrue(viewController.updateProfileDetailsCalled)
        } else {
            XCTAssertFalse(viewController.updateProfileDetailsCalled)
        }
    }

    func testCleanAvatarAndLabelsAfterLogout() {
        //given
        let viewController = ProfileViewController()
        let spy = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        spy.presenter = presenter
        presenter.view = spy

        self.viewControllerSpy = spy
        self.presenter = presenter

        //when
        presenter.didTapLogout()

        //then
        XCTAssertTrue(spy.cleanAvatarAndLabelsCalled)
    }
}
