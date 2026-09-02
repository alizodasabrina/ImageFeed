//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Sabrina Mavlyanova on 28/08/26.
//

@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {}

    func code(from url: URL) -> String? {
        return nil
    }
}
