// ShimmerMovieCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с шимером
final class ShimmerMovieCell: UICollectionViewCell {
    // MARK: - Constants

    static let reuseId = "ShimmerMovieCell"

    // MARK: - Visual components

    private let posterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let nameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Initializators

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        for view in [nameView, posterView] {
            view.layoutIfNeeded()
            let shimmerLayer = ShimmerLayer(clearCollor: .clear)
            view.layer.addSublayer(shimmerLayer)
            shimmerLayer.frame = view.bounds
        }
    }

    // MARK: - Private methods

    private func setViews() {
        setPosterConstraints()
        setNameConstraints()
    }

    private func setPosterConstraints() {
        contentView.addSubview(posterView)
        NSLayoutConstraint.activate([
            posterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterView.topAnchor.constraint(equalTo: topAnchor),
            posterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48)
        ])
    }

    private func setNameConstraints() {
        addSubview(nameView)
        NSLayoutConstraint.activate([
            nameView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameView.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 8),
            nameView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
