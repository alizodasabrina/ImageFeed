//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 01/06/26.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    // MARK: - Constants

    static let reuseIdentifier = "ImagesListCell"

    private enum Constants {
        static let gradientHeight: CGFloat = 30
        static let gradientLocation: NSNumber = 0.5393
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!

    // MARK: - Properties

    private let gradientLayer = CAGradientLayer()

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setupGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = CGRect(
            x: 0,
            y: photoImageView.bounds.height - Constants.gradientHeight,
            width: photoImageView.bounds.width,
            height: Constants.gradientHeight
        )
    }

    // MARK: - Public Methods

    func configure(image: UIImage, date: String, isLiked: Bool) {
        photoImageView.image = image
        dateLabel.text = date

        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }

    // MARK: - Private Methods

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 0).cgColor,
            UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 0.2).cgColor
        ]
        gradientLayer.locations = [0, Constants.gradientLocation]
        photoImageView.layer.addSublayer(gradientLayer)
    }
}
