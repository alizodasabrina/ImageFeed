//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 11/07/26.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {

    // MARK: - Private Properties

    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }

    // MARK: - Public Methods

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
