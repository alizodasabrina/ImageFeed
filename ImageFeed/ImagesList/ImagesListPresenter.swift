//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 29/08/26.
//

import Foundation

// MARK: - ImagesListViewControllerProtocol

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated()
}

// MARK: - ImagesListPresenterProtocol

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func didChangeNotification()
}

// MARK: - ImagesListPresenter

final class ImagesListPresenter: ImagesListPresenterProtocol {

    // MARK: - Public Properties

    weak var view: ImagesListViewControllerProtocol?

    private var imagesListServiceObserver: NSObjectProtocol?

    // MARK: - Init

    init() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.didChangeNotification()
            }
    }

    // MARK: - Public Methods

    func viewDidLoad() {
        if ImagesListService.shared.photos.isEmpty {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }

    func fetchPhotosNextPage() {
        ImagesListService.shared.fetchPhotosNextPage()
    }

    func didChangeNotification() {
        view?.updateTableViewAnimated()
    }
}
