//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 12/07/26.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        if let imagesListViewController = imagesListViewController as? ImagesListViewController {
            let imagesListPresenter = ImagesListPresenter()
            imagesListViewController.presenter = imagesListPresenter
            imagesListPresenter.view = imagesListViewController
        }

        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )

        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
