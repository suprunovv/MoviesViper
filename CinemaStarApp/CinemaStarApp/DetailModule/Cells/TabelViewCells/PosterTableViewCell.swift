// PosterTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка фильма с постером, названием и кнопкой "Смотреть"
final class PosterTableViewCell: UITableViewCell {
    // MARK: - Constants

    private enum Constants {
        static let lockButtonTitle = "Смотреть"
    }

    static let reuseId = "PosterTableViewCell"

    // MARK: - Visual Components

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let lookButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.lockButtonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .lookButtonColor
        button.layer.cornerRadius = 12
        return button
    }()

    // MARK: - Public property

    var buttonHandler: (() -> ())?

    // MARK: - Initializators

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }

    // MARK: - Public methods

    func configureCell(movie: MovieDetail) {
        nameLabel.text = movie.name
        ratingLabel.text = "⭐ \(movie.rating)"
    }

    func setPoster(_ image: UIImage?) {
        guard let image else { return }
        posterImageView.image = image
    }

    // MARK: - Private methods

    private func setup() {
        selectionStyle = .none
        setPosterConstraints()
        setNameLabelConstraints()
        setRatingLabel()
        setLookButtonConstraints()
        backgroundColor = .clear
    }

    private func setPosterConstraints() {
        addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 170),
            posterImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setNameLabelConstraints() {
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 16
            ),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        ])
    }

    private func setRatingLabel() {
        addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            ratingLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 16
            ),
            ratingLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor),
        ])
    }

    private func setLookButtonConstraints() {
        addSubview(lookButton)
        buttonAddTarget()
        NSLayoutConstraint.activate([
            lookButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            lookButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.92),
            lookButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            lookButton.heightAnchor.constraint(equalToConstant: 44),
            lookButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func buttonAddTarget() {
        lookButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }

    @objc private func tapButton() {
        buttonHandler?()
    }
}
