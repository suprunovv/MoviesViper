// MoviesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Вью экрана с фильмами
final class MoviesViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let layoutLineSpacing: CGFloat = 18
        static let layoutInteritemSpacing: CGFloat = 14
        static let titleText = "Смотри исторические \nфильмы на"
        static let nameApp = "CINEMA STAR"
    }

    // MARK: - Visual Components

    private var moviesCollectionView: UICollectionView?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Private property

    private var movies: [Movie]?
    private let gradientLayer = CAGradientLayer()
    private var loadingState: LoadingState<[Movie]> = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.moviesCollectionView?.reloadData()
            }
        }
    }

    // MARK: - Public Property

    var viewModel: MoviesViewModelProtocol?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setTitleLabelConstraints()
        setupMoviesCollectionView()
        updateState()
        setGradient()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: Private methods

    private func setGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.backgroudOne.cgColor,
            UIColor.backgroudTwo.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func updateState() {
        viewModel?.loadingState = { [weak self] result in
            switch result {
            case .loading:
                self?.loadingState = .loading
            case let .sucsess(data):
                self?.movies = data
                self?.loadingState = .sucsess(data)
            default:
                break
            }
        }
    }

    private func makeFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.layoutLineSpacing
        layout.minimumInteritemSpacing = Constants.layoutInteritemSpacing
        return layout
    }

    private func setupMoviesCollectionView() {
        moviesCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeFlowLayout()
        )
        guard let moviesCollectionView else { return }
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.reuseId
        )
        moviesCollectionView.register(
            ShimmerMovieCell.self,
            forCellWithReuseIdentifier: ShimmerMovieCell.reuseId
        )
        view.addSubview(moviesCollectionView)
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 14
            ),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        moviesCollectionView.backgroundColor = .clear
    }

    private func getAtributedString() -> NSAttributedString {
        let fullString = "\(Constants.titleText) \(Constants.nameApp)"
        let atributedString = NSMutableAttributedString(string: fullString)
        atributedString.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 20),
            range: (fullString as NSString).range(of: Constants.titleText)
        )
        atributedString.addAttribute(
            .font,
            value: UIFont.boldSystemFont(ofSize: 20),
            range: (fullString as NSString).range(of: Constants.nameApp)
        )
        return atributedString
    }

    private func setTitleLabelConstraints() {
        view.addSubview(titleLabel)
        titleLabel.attributedText = getAtributedString()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}

// MARK: - MoviesViewController + UICollectionViewDataSource

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch loadingState {
        case let .sucsess(data):
            return data.count
        default:
            return 6
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch loadingState {
        case let .sucsess(movies):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCollectionViewCell.reuseId,
                for: indexPath
            ) as? MovieCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(movie: movies[indexPath.item])
            viewModel?.getImage(url: movies[indexPath.item].image) { image in
                cell.setImage(image: image)
            }
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ShimmerMovieCell.reuseId,
                for: indexPath
            ) as? ShimmerMovieCell else { return UICollectionViewCell() }
            return cell
        }
    }
}

// MARK: - MoviesViewController + UICollectionViewDelegateFlowLayout

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(
            width: view.bounds.width / 2 - 25,
            height: view.bounds.width / 2 + 48
        )
    }
}

// MARK: - MoviesViewController + UICollectionViewDelegate

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = movies?[indexPath.item] else { return }
        viewModel?.goToDetailsScreen(movieId: movie.id)
    }
}
