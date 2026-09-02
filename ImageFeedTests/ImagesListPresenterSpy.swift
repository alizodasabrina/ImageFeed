//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Sabrina Mavlyanova on 29/08/26.
//

@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var fetchPhotosNextPageCalled: Bool = false
    var view: ImagesListViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }

    func didChangeNotification() {}
}
