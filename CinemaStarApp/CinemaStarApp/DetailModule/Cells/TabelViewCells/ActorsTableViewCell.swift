// ActorsTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с актерами
final class ActorsTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let reuseId = "ActorsTableViewCell"

    private enum Constants {
        static let spaseLayout: CGFloat = 22
        static let title = "Актеры и съемочная группа"
        static let languageTitle = "Язык"
    }

    // MARK: - Visual Components

    private lazy var actorsCollectionView: UICollectionView = {
        let actorsCollectionView = UICollectionView(frame: .null, collectionViewLayout: makeFlowLayout())
        actorsCollectionView.register(
            ActorCollectionViewCell.self,
            forCellWithReuseIdentifier: ActorCollectionViewCell.reuseId
        )
        actorsCollectionView.backgroundColor = .clear
        actorsCollectionView.dataSource = self
        actorsCollectionView.delegate = self
        actorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        actorsCollectionView.showsHorizontalScrollIndicator = false
        return actorsCollectionView
    }()

    private let languageTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = Constants.languageTitle
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.alpha = 0.41
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

    private var viewModel: DetailViewModelProtocol?

    private var actors: [Actor] = [] {
        didSet {
            actorsCollectionView.reloadData()
        }
    }

    // MARK: - Initializators

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
    }

    // MARK: - Public methods

    func configure(viewModel: DetailViewModelProtocol?, actors: [Actor], language: String) {
        self.actors = actors
        self.viewModel = viewModel
        languageLabel.text = language
    }

    // MARK: - Private methods

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        setTitleLabelConstaints()
        setCollectionViewConstraints()
        setLanguageTitleConstraints()
        setLanguageConstraints()
    }

    private func makeFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.spaseLayout
        layout.minimumInteritemSpacing = Constants.spaseLayout
        return layout
    }

    private func setCollectionViewConstraints() {
        addSubview(actorsCollectionView)
        NSLayoutConstraint.activate([
            actorsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            actorsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            actorsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            actorsCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setTitleLabelConstaints() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }

    private func setLanguageTitleConstraints() {
        addSubview(languageTitleLabel)
        NSLayoutConstraint.activate([
            languageTitleLabel.topAnchor.constraint(equalTo: actorsCollectionView.bottomAnchor, constant: 14),
            languageTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        ])
    }

    private func setLanguageConstraints() {
        addSubview(languageLabel)
        NSLayoutConstraint.activate([
            languageLabel.topAnchor.constraint(equalTo: languageTitleLabel.bottomAnchor, constant: 4),
            languageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            languageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - ActorsTableViewCell + UICollectionViewDataSource

extension ActorsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        actors.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ActorCollectionViewCell.reuseId,
            for: indexPath
        ) as? ActorCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(actor: actors[indexPath.item])
        viewModel?.getImage(url: actors[indexPath.item].photoUrl) { image in
            cell.setPhoto(image: image)
        }
        return cell
    }
}

// MARK: - ActorsTableViewCell + UICollectionViewDelegateFlowLayout

extension ActorsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 46, height: 100)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
    }
}
