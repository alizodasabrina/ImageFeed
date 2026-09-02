//
//  WebViewTests.swift
//  ImageFeedTests
//
//  Created by Sabrina Mavlyanova on 28/08/26.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {

    // MARK: - Properties

    private var viewControllerSpy: WebViewViewControllerSpy?
    private var authHelper: AuthHelper?
    private var presenter: WebViewPresenter?

    override func tearDown() {
        viewControllerSpy = nil
        authHelper = nil
        presenter = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }

    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController

        self.viewControllerSpy = viewController
        self.authHelper = authHelper
        self.presenter = presenter

        //when
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }

    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6

        self.authHelper = authHelper
        self.presenter = presenter

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertFalse(shouldHideProgress)
    }

    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper() //Dummy
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0

        self.authHelper = authHelper
        self.presenter = presenter

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress) // return value verification

        //then
        XCTAssertTrue(shouldHideProgress)
    }
}
