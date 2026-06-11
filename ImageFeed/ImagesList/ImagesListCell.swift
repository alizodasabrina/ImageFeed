//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 01/06/26.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!

    private let gradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()

        gradientLayer.colors = [
            UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 0).cgColor,
            UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 0.2).cgColor
        ]
        gradientLayer.locations = [0, 0.5393]
        cellImage.layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let gradientHeight: CGFloat = 30
        gradientLayer.frame = CGRect(
            x: 0,
            y: cellImage.bounds.height - gradientHeight,
            width: cellImage.bounds.width,
            height: gradientHeight
        )
    }

    func configure(image: UIImage, date: String, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = date

        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
