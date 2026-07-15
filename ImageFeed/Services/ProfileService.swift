//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 11/07/26.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}

final class ProfileService {

    // MARK: - Singleton

    static let shared = ProfileService()

    private init() {}

    // MARK: - Public Properties

    private(set) var profile: Profile?

    // MARK: - Private Properties

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?

    // MARK: - Public Methods

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)

        task?.cancel()

        guard let request = makeProfileRequest(token: token) else {
            print("[ProfileService.fetchProfile]: invalidRequest")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let profileResult):
                let profile = Profile(
                    username: profileResult.username,
                    name: "\(profileResult.firstName) \(profileResult.lastName)"
                        .trimmingCharacters(in: .whitespaces),
                    loginName: "@\(profileResult.username)",
                    bio: profileResult.bio
                )
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("[ProfileService.fetchProfile]: \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }

        self.task = task
        task.resume()
    }

    // MARK: - Private Methods

    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURLString)/me") else {
            print("[ProfileService.makeProfileRequest]: failed to create URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
