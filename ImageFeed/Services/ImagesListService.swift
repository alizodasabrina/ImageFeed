//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 23/07/26.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Decodable {
    let thumb: String
    let full: String
}

final class ImagesListService {

    // MARK: - Notification

    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    // MARK: - Singleton

    static let shared = ImagesListService()

    private init() {}

    // MARK: - Public Properties

    private(set) var photos: [Photo] = []

    // MARK: - Private Properties

    private let tokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    // MARK: - Public Methods

    func fetchPhotosNextPage() {
        guard task == nil else { return }

        let nextPage = (lastLoadedPage ?? 0) + 1

        guard let request = makePhotosRequest(page: nextPage) else {
            print("[ImagesListService.fetchPhotosNextPage]: invalidRequest")
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { photoResult in
                    Photo(
                        id: photoResult.id,
                        size: CGSize(width: CGFloat(photoResult.width), height: CGFloat(photoResult.height)),
                        createdAt: photoResult.createdAt.flatMap { self.dateFormatter.date(from: $0) },
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser
                    )
                }
                self.lastLoadedPage = nextPage
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
                }
            case .failure(let error):
                print("[ImagesListService.fetchPhotosNextPage]: \(error)")
            }
            self.task = nil
        }

        self.task = task
        task.resume()
    }

    // MARK: - Private Methods

    private func makePhotosRequest(page: Int) -> URLRequest? {
        guard let token = tokenStorage.token else {
            print("[ImagesListService.makePhotosRequest]: token is missing")
            return nil
        }

        guard let url = URL(string: "\(Constants.defaultBaseURLString)/photos?page=\(page)&per_page=10") else {
            print("[ImagesListService.makePhotosRequest]: failed to create URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
}
