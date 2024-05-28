// DescriptionTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с описанием фильма
final class DescriptionTableViewCell: UITableViewCell {
    private enum DescriptionState {
        /// Текст открыт
        case open
        /// Текст закрыт
        case close

        mutating func update() {
            switch self {
            case .open:
                self = .close
            case .close:
                self = .open
            }
        }
    }

    // MARK: - Constants

    static let reuseId = "DescriptionTableViewCell"

    // MARK: - Visual componetns

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let informationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.alpha = 0.41
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let openButton: UIButton = {
        let button = UIButton()
        button.setImage(.chevronDown, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()

    private var state: DescriptionState = .close

    // MARK: - Public property

    var handler: (() -> ())?

    // MARK: - Initializators

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }

    // MARK: - Public methods

    func configure(movie: MovieDetail) {
        descriptionLabel.text = movie.deskription
        informationLabel.text = "\(movie.year) / \(movie.country) / \(movie.type)"
    }

    // MARK: - Private methods

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        setDescriptionConstaints()
        setOpenButton()
        setInformationLabelConstraints()
    }

    private func setDescriptionConstaints() {
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
    }

    private func setInformationLabelConstraints() {
        addSubview(informationLabel)
        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            informationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            informationLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setOpenButton() {
        addSubview(openButton)
        openButton.addTarget(
            self,
            action: #selector(tapOpen),
            for: .touchUpInside
        )
        NSLayoutConstraint.activate([
            openButton.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 10),
            openButton.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5)
        ])
    }

    @objc private func tapOpen() {
        switch state {
        case .open:
            descriptionLabel.numberOfLines = 4
            openButton.setImage(.chevronDown, for: .normal)
            state.update()
        case .close:
            descriptionLabel.numberOfLines = 0
            openButton.setImage(.chevronUp, for: .normal)
            state.update()
        }
        handler?()
    }
}
