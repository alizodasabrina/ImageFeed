//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Sabrina Mavlyanova on 29/08/26.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {

    // MARK: - Properties

    private var viewControllerSpy: ImagesListViewControllerSpy?
    private var presenter: ImagesListPresenter?

    override func tearDown() {
        viewControllerSpy = nil
        presenter = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }

    func testPresenterNotifiesViewOnChange() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        self.viewControllerSpy = viewController
        self.presenter = presenter

        //when
        presenter.didChangeNotification()

        //then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled) //behaviour verification
    }
}
