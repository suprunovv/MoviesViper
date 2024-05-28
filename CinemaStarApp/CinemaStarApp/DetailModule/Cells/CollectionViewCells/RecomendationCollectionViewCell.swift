// RecomendationCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

// Ячейка рекомендованного фильма
final class RecomendationCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    static let reuseId = "RecomendationCollectionViewCell"

    // MARK: - Visual components

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
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

    func setup(movie: SimilarMovie) {
        nameLabel.text = movie.name
    }

    func setPoster(image: UIImage?) {
        guard let image else { return }
        posterImageView.image = image
    }

    // MARK: - Private methods

    private func setViews() {
        backgroundColor = .clear
        setPosterConstrains()
        setNameLabelConstraints()
    }

    private func setPosterConstrains() {
        contentView.addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 170),
            posterImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setNameLabelConstraints() {
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 1),
            nameLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
