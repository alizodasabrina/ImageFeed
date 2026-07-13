//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 11/07/26.
//

import Foundation

struct ProfileImage: Codable {
    let small: String
}

struct UserResult: Codable {
    let profileImage: ProfileImage
}

final class ProfileImageService {

    // MARK: - Notification

    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    // MARK: - Singleton

    static let shared = ProfileImageService()

    private init() {}

    // MARK: - Public Properties

    private(set) var avatarURL: String?

    // MARK: - Private Properties

    private let tokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?

    // MARK: - Public Methods

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        task?.cancel()

        guard let token = tokenStorage.token else {
            print("[ProfileImageService]: token is missing")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        guard let request = makeProfileImageRequest(username: username, token: token) else {
            print("[ProfileImageService]: invalidRequest")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let userResult):
                let avatarURL = userResult.profileImage.small
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL]
                    )
            case .failure(let error):
                print("[ProfileImageService.fetchProfileImageURL]: \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }

        self.task = task
        task.resume()
    }

    // MARK: - Private Methods

    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURLString)/users/\(username)") else {
            print("[ProfileImageService.makeProfileImageRequest]: failed to create URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
