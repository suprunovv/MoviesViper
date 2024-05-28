// ActorCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с данными актера
final class ActorCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    static let reuseId = "ActorCollectionViewCell"

    // MARK: - Visual components

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 8)
        label.textAlignment = .center
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

    func setup(actor: Actor) {
        nameLabel.text = actor.name
    }

    func setPhoto(image: UIImage?) {
        guard let image else { return }
        avatarImageView.image = image
    }

    // MARK: - Private methods

    private func setViews() {
        backgroundColor = .clear
        setAvatarConstrains()
        setNameLabelConstraints()
    }

    private func setAvatarConstrains() {
        contentView.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 46),
            avatarImageView.heightAnchor.constraint(equalToConstant: 73)
        ])
    }

    private func setNameLabelConstraints() {
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 1),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
