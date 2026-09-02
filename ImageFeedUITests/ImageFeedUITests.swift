//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Sabrina Mavlyanova on 29/08/26.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    // MARK: - Properties

    private let app = XCUIApplication()

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launch()
    }

    // MARK: - Private Methods

    private var unsplashEmail: String {
        ProcessInfo.processInfo.environment["UNSPLASH_EMAIL"] ?? ""
    }

    private var unsplashPassword: String {
        ProcessInfo.processInfo.environment["UNSPLASH_PASSWORD"] ?? ""
    }

    // MARK: - Tests

    func testAuth() throws {
        //given — приложение запущено, показан экран авторизации
        let authenticateButton = app.buttons["authenticate button"]

        //when
        XCTAssertTrue(authenticateButton.waitForExistence(timeout: 5))
        authenticateButton.tap()

        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 10))

        // Ввести данные в форму
        let loginTextField = webView.textFields.element(boundBy: 0)
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        loginTextField.tap()
        loginTextField.typeText(unsplashEmail)

        let passwordTextField = webView.secureTextFields.element(boundBy: 0)
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(unsplashPassword)

        // Нажать кнопку логина
        webView.buttons.element(boundBy: 0).tap()

        // Подождать, пока открывается экран ленты
        let tables = app.tables.firstMatch
        XCTAssertTrue(tables.waitForExistence(timeout: 15))

        //then
        XCTAssertTrue(tables.exists)
    }

    func testFeed() throws {
        let tablesQuery = app.tables

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let likeButtonOff = cellToLike.buttons["like button off"]
        XCTAssertTrue(likeButtonOff.waitForExistence(timeout: 5))
        likeButtonOff.tap()

        let likeButtonOn = cellToLike.buttons["like button on"]
        XCTAssertTrue(likeButtonOn.waitForExistence(timeout: 5))
        likeButtonOn.tap()
        XCTAssertTrue(likeButtonOff.waitForExistence(timeout: 5))

        cellToLike.tap()

        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        let profileTabButton = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(profileTabButton.waitForExistence(timeout: 5))
        profileTabButton.tap()

        let expectedName = try XCTUnwrap(
            ProcessInfo.processInfo.environment["UNSPLASH_NAME"],
            "UNSPLASH_NAME env var must be set to run testProfile"
        )
        let expectedLogin = try XCTUnwrap(
            ProcessInfo.processInfo.environment["UNSPLASH_LOGIN"],
            "UNSPLASH_LOGIN env var must be set to run testProfile"
        )

        XCTAssertTrue(app.staticTexts[expectedName].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[expectedLogin].exists)

        app.buttons["logout button"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()

        XCTAssertTrue(app.buttons["authenticate button"].waitForExistence(timeout: 5))
    }
}
