//
//  AuthHelperTests.swift
//  ImageFeedTests
//
//  Created by Sabrina Mavlyanova on 29/08/26.
//

@testable import ImageFeed
import XCTest

final class AuthHelperTests: XCTestCase {

    // MARK: - Properties

    private let authHelper = AuthHelper()

    // MARK: - Tests

    func testCodeFromURL() throws {
        //given
        let url = try XCTUnwrap(URL(string: "https://unsplash.com/oauth/authorize/native?code=test_code"))

        //when
        let code = authHelper.code(from: url)

        //then
        XCTAssertEqual(code, "test_code") // return value verification
    }

    func testCodeFromURLWithWrongPath() throws {
        //given
        let url = try XCTUnwrap(URL(string: "https://unsplash.com/noauth/authorize/native?code=test_code"))

        //when
        let code = authHelper.code(from: url)

        //then
        XCTAssertNil(code)
    }

    func testCodeFromURLWithoutCodeParameter() throws {
        //given
        let url = try XCTUnwrap(URL(string: "https://unsplash.com/oauth/authorize/native?not_code=other"))

        //when
        let code = authHelper.code(from: url)

        //then
        XCTAssertNil(code)
    }

    func testAuthRequestURL() {
        //given
        let configuration = AuthConfiguration.standard

        //when
        let request = authHelper.authRequest()

        //then
        let url = request?.url
        let components = url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
        XCTAssertEqual(components?.scheme, "https")
        XCTAssertEqual(components?.host, "unsplash.com")
        XCTAssertEqual(components?.path, "/oauth/authorize")
        let items = components?.queryItems ?? []
        XCTAssertTrue(items.contains(URLQueryItem(name: "client_id", value: configuration.accessKey)))
        XCTAssertTrue(items.contains(URLQueryItem(name: "redirect_uri", value: configuration.redirectURI)))
        XCTAssertTrue(items.contains(URLQueryItem(name: "response_type", value: "code")))
        XCTAssertTrue(items.contains(URLQueryItem(name: "scope", value: configuration.accessScope)))
    }
}
