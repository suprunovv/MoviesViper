// ShimmerPosterCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

// Ячейка постера с шимером
final class ShimmerPosterCell: UITableViewCell {
    // MARK: - Constants

    static let reuseId = "ShimmerPosterCell"

    // MARK: - Visual components

    private let posterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let ratingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let typeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let actorsTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let actorsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let languageTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let languageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let similarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let recomendationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let recomendNameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Initializators

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setViews()
    }

    // MARK: - Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews.filter({ $0 !== actorsView && $0 !== contentView }) + actorsView.subviews {
            view.layoutIfNeeded()
            let shimmerLayer = ShimmerLayer(clearCollor: .clear)
            view.layer.addSublayer(shimmerLayer)
            shimmerLayer.frame = view.bounds
        }
    }

    // MARK: - Private methods

    private func setViews() {
        backgroundColor = .clear
        setPosterConstraints()
        setRatingConstraints()
        setButtonConstraints()
        setDescritionConstraint()
        setTypeConstraints()
        setActorsTitleConstraints()
        setActorsViewConstraints()
        setActorsViews()
        setLanguageConstraints()
        setRecomendationConstraints()
    }

    private func setPosterConstraints() {
        addSubview(posterView)
        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: topAnchor),
            posterView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            posterView.widthAnchor.constraint(equalToConstant: 170),
            posterView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setRatingConstraints() {
        addSubview(ratingView)
        NSLayoutConstraint.activate([
            ratingView.centerYAnchor.constraint(equalTo: posterView.centerYAnchor),
            ratingView.leadingAnchor.constraint(
                equalTo: posterView.trailingAnchor,
                constant: 16
            ),
            ratingView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            ratingView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }

    private func setButtonConstraints() {
        addSubview(buttonView)
        NSLayoutConstraint.activate([
            buttonView.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 16),
            buttonView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.92),
            buttonView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setDescritionConstraint() {
        addSubview(descriptionView)
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: 16),
            descriptionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionView.heightAnchor.constraint(equalToConstant: 100),
            descriptionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.92)
        ])
    }

    private func setTypeConstraints() {
        addSubview(typeView)
        NSLayoutConstraint.activate([
            typeView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 10),
            typeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            typeView.widthAnchor.constraint(equalToConstant: 200),
            typeView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setActorsTitleConstraints() {
        addSubview(actorsTitleView)
        NSLayoutConstraint.activate([
            actorsTitleView.topAnchor.constraint(equalTo: typeView.bottomAnchor, constant: 16),
            actorsTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actorsTitleView.widthAnchor.constraint(equalToConstant: 200),
            actorsTitleView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    private func setActorsViewConstraints() {
        addSubview(actorsView)
        NSLayoutConstraint.activate([
            actorsView.topAnchor.constraint(equalTo: actorsTitleView.bottomAnchor, constant: 10),
            actorsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actorsView.heightAnchor.constraint(equalToConstant: 100),
            actorsView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func setLanguageConstraints() {
        addSubview(languageTitleView)
        NSLayoutConstraint.activate([
            languageTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            languageTitleView.topAnchor.constraint(equalTo: actorsView.bottomAnchor, constant: 14),
            languageTitleView.heightAnchor.constraint(equalToConstant: 20),
            languageTitleView.widthAnchor.constraint(equalToConstant: 200)
        ])
        addSubview(languageView)
        NSLayoutConstraint.activate([
            languageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            languageView.topAnchor.constraint(equalTo: languageTitleView.bottomAnchor, constant: 4),
            languageView.heightAnchor.constraint(equalToConstant: 20),
            languageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        addSubview(similarView)
        NSLayoutConstraint.activate([
            similarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            similarView.topAnchor.constraint(equalTo: languageView.bottomAnchor, constant: 10),
            similarView.heightAnchor.constraint(equalToConstant: 20),
            similarView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setRecomendationConstraints() {
        addSubview(recomendationView)
        NSLayoutConstraint.activate([
            recomendationView.topAnchor.constraint(equalTo: similarView.bottomAnchor, constant: 8),
            recomendationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recomendationView.widthAnchor.constraint(equalToConstant: 170),
            recomendationView.heightAnchor.constraint(equalToConstant: 200)
        ])
        addSubview(recomendNameView)
        NSLayoutConstraint.activate([
            recomendNameView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recomendNameView.topAnchor.constraint(equalTo: recomendationView.bottomAnchor, constant: 10),
            recomendNameView.heightAnchor.constraint(equalToConstant: 20),
            recomendNameView.widthAnchor.constraint(equalToConstant: 200),
            recomendationView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setActorsViews() {
        var space: CGFloat = 16
        for _ in 1 ... 6 {
            let view = UIView()
            actorsView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.clipsToBounds = true
            view.layer.cornerRadius = 8
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: space),
                view.topAnchor.constraint(equalTo: actorsView.topAnchor),
                view.heightAnchor.constraint(equalTo: actorsView.heightAnchor),
                view.widthAnchor.constraint(equalToConstant: 60)
            ])
            space += 76
        }
    }
}
