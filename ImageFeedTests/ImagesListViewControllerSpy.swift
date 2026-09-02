//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Sabrina Mavlyanova on 29/08/26.
//

@testable import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?

    var updateTableViewAnimatedCalled: Bool = false

    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
}
