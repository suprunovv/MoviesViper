// MovieCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка фильма
final class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    static let reuseId = "MovieCollectionViewCell"

    // MARK: - Visual components

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializators

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public methods

    func configure(movie: Movie) {
        nameLabel.text = movie.name
        ratingLabel.text = "⭐ \(movie.rating)"
    }

    func setImage(image: UIImage?) {
        guard let image else { return }
        posterImageView.image = image
    }

    // MARK: - Private Mhetods

    private func setViews() {
        setPosterConstraints()
        setNameLabelConstraints()
        setRatingLabelConstraints()
    }

    private func setPosterConstraints() {
        contentView.addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48)
        ])
    }

    private func setNameLabelConstraints() {
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setRatingLabelConstraints() {
        addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3)
        ])
    }
}
