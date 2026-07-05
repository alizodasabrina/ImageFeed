//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 12/06/26.
//

import UIKit

final class SingleImageViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let minimumZoomScale: CGFloat = 0.1
        static let maximumZoomScale: CGFloat = 1.25
    }

    // MARK: - Public Properties

    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }

            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = Constants.minimumZoomScale
        scrollView.maximumZoomScale = Constants.maximumZoomScale

        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }

    // MARK: - IBActions

    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTapShareButton() {
        guard let image else { return }

        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }

    // MARK: - Private Methods

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
