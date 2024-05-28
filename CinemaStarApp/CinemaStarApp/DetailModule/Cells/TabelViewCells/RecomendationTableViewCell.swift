// RecomendationTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с рекомендованными фильмами
final class RecomendationTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let reuseId = "RecomendationTableViewCell"

    private enum Constants {
        static let spaceLayout: CGFloat = 16
        static let title = "Смотрите также"
    }

    // MARK: - Visual Components

    private lazy var moviesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .null, collectionViewLayout: makeFlowLayout())
        collectionView.register(
            RecomendationCollectionViewCell.self,
            forCellWithReuseIdentifier: RecomendationCollectionViewCell.reuseId
        )
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.title
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Private property

    private var movies: [SimilarMovie] = [] {
        didSet {
            moviesCollectionView.reloadData()
        }
    }

    private var viewModel: DetailViewModelProtocol?

    // MARK: - Initializators

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }

    // MARK: - Public methods

    func configure(movies: [SimilarMovie], viewModel: DetailViewModelProtocol?) {
        self.movies = movies
        self.viewModel = viewModel
    }

    // MARK: - Private methods

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        setTitleConstaints()
        setCollectionViewConstraints()
    }

    private func makeFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.spaceLayout
        layout.minimumInteritemSpacing = Constants.spaceLayout
        return layout
    }

    private func setCollectionViewConstraints() {
        addSubview(moviesCollectionView)
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            moviesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moviesCollectionView.heightAnchor.constraint(equalToConstant: 248),
            moviesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setTitleConstaints() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
}

// MARK: - RecomendationTableViewCell + UICollectionViewDataSource

extension RecomendationTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecomendationCollectionViewCell.reuseId,
            for: indexPath
        ) as? RecomendationCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(movie: movies[indexPath.item])
        if let viewModel {
            viewModel.getImage(url: movies[indexPath.item].posterUrl) { image in
                cell.setPoster(image: image)
            }
        }
        return cell
    }
}

extension RecomendationTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 170, height: 248)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}
