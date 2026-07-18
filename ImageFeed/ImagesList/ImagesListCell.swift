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
        static let cornerRadius: CGFloat = 16
        static let imageTopInset: CGFloat = 4
        static let imageSideInset: CGFloat = 16
        static let imageBottomInset: CGFloat = 4
        static let likeButtonSize: CGFloat = 44
        static let dateLabelInset: CGFloat = 8
        static let dateFontSize: CGFloat = 13
        static let gradientHeight: CGFloat = 30
        static let gradientLocation: NSNumber = 0.5393
        static let backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
    }

    // MARK: - Subviews

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.dateFontSize)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Properties

    private let gradientLayer = CAGradientLayer()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        setupGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

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

        let likeImage = (isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off"))?.withRenderingMode(.alwaysOriginal)
        likeButton.setImage(likeImage, for: .normal)
    }

    // MARK: - Private Methods

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = Constants.backgroundColor
        selectionStyle = .none

        contentView.addSubview(photoImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(dateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.imageTopInset),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.imageSideInset),
            contentView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: Constants.imageSideInset),
            contentView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: Constants.imageBottomInset),

            likeButton.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: likeButton.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.likeButtonSize),

            dateLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: Constants.dateLabelInset),
            photoImageView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.dateLabelInset)
        ])
    }

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 0).cgColor,
            UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 0.2).cgColor
        ]
        gradientLayer.locations = [0, Constants.gradientLocation]
        photoImageView.layer.addSublayer(gradientLayer)
    }
}
