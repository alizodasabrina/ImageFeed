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

        sleep(2)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)

        cellToLike.buttons["like button off"].tap()
        cellToLike.buttons["like button on"].tap()

        sleep(2)

        cellToLike.tap()

        sleep(2)

        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        let expectedName = ProcessInfo.processInfo.environment["UNSPLASH_NAME"] ?? ""
        let expectedLogin = ProcessInfo.processInfo.environment["UNSPLASH_LOGIN"] ?? ""

        if !expectedName.isEmpty {
            XCTAssertTrue(app.staticTexts[expectedName].exists)
        }
        if !expectedLogin.isEmpty {
            XCTAssertTrue(app.staticTexts[expectedLogin].exists)
        }

        app.buttons["logout button"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()

        XCTAssertTrue(app.buttons["authenticate button"].waitForExistence(timeout: 5))
    }
}
