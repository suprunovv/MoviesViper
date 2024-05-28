// DetailViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран детального описания фильма
final class DetailViewController: UIViewController {
    private enum Constants {
        static let alertTitle = "Упс!"
        static let alertMessage = "Функционал в разработке :("
        static let alertActionTitle = "Ok"
    }

    // MARK: - Visual Components

    private var detailTableView = UITableView()

    // MARK: - Private property

    private var loadingState: LoadingState<MovieDetail> = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.detailTableView.reloadData()
            }
        }
    }

    private let gradientLayer = CAGradientLayer()

    private var detailMovie: MovieDetail?

    // MARK: - Public property

    var viewModel: DetailViewModelProtocol?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setGradient()
        updateData()
        setupNavigationBar()
        updateFavoriteState()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevron,
            style: .done,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .heart,
            style: .done,
            target: self,
            action: #selector(updateFavorite)
        )
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    private func updateFavoriteState() {
        viewModel?.favoriteState = { [weak self] result in
            switch result {
            case .saved:
                self?.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: .fillHeart,
                    style: .done,
                    target: self,
                    action: #selector(self?.updateFavorite)
                )
                self?.navigationItem.rightBarButtonItem?.tintColor = .white
            case .unsaved:
                self?.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: .heart,
                    style: .done,
                    target: self,
                    action: #selector(self?.updateFavorite)
                )
                self?.navigationItem.rightBarButtonItem?.tintColor = .white
            }
        }
    }

    private func updateData() {
        viewModel?.loadingState = { [weak self] result in
            switch result {
            case .loading:
                self?.loadingState = .loading
            case let .sucsess(data):
                self?.loadingState = .sucsess(data)
            default:
                break
            }
        }
    }

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

    private func setupTableView() {
        detailTableView.backgroundColor = .clear
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.separatorStyle = .none
        detailTableView.register(
            PosterTableViewCell.self,
            forCellReuseIdentifier: PosterTableViewCell.reuseId
        )
        detailTableView.register(
            DescriptionTableViewCell.self,
            forCellReuseIdentifier: DescriptionTableViewCell.reuseId
        )
        detailTableView.register(ActorsTableViewCell.self, forCellReuseIdentifier: ActorsTableViewCell.reuseId)
        detailTableView.register(
            RecomendationTableViewCell.self,
            forCellReuseIdentifier: RecomendationTableViewCell.reuseId
        )
        detailTableView.register(ShimmerPosterCell.self, forCellReuseIdentifier: ShimmerPosterCell.reuseId)
        view.addSubview(detailTableView)
        detailTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: Constants.alertTitle,
            message: Constants.alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Constants.alertActionTitle, style: .cancel))
        present(alert, animated: true)
    }

    @objc private func goBack() {
        viewModel?.closeDetailScreen()
    }

    @objc private func updateFavorite() {
        viewModel?.updateFavorite()
    }
}

// MARK: - DetailViewController + UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = viewModel?.sectionTypes else { return 0 }
        switch loadingState {
        case .sucsess:
            return sections.count
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = viewModel?.sectionTypes[indexPath.section] else {
            return UITableViewCell()
        }
        switch loadingState {
        case let .sucsess(movie):
            switch cellType {
            case .poster:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: PosterTableViewCell.reuseId,
                    for: indexPath
                ) as? PosterTableViewCell else { return UITableViewCell() }
                cell.configureCell(movie: movie)
                viewModel?.getImage(url: movie.posterUrl) { image in
                    cell.setPoster(image)
                }
                cell.buttonHandler = { [weak self] in
                    self?.showAlert()
                }
                return cell
            case .description:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DescriptionTableViewCell.reuseId,
                    for: indexPath
                ) as? DescriptionTableViewCell else { return UITableViewCell() }
                cell.configure(movie: movie)

                cell.handler = { tableView.reloadSections(IndexSet(integer: 2), with: .automatic) }

                return cell
            case .actors:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ActorsTableViewCell.reuseId,
                    for: indexPath
                ) as? ActorsTableViewCell else { return UITableViewCell() }
                cell.configure(
                    viewModel: viewModel,
                    actors: movie.actors,
                    language: movie.language ?? "none"
                )
                return cell
            case .recommendations:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecomendationTableViewCell.reuseId,
                    for: indexPath
                ) as? RecomendationTableViewCell else { return UITableViewCell() }
                cell.configure(movies: movie.semilarMovies ?? [], viewModel: viewModel)
                return cell
            }
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ShimmerPosterCell.reuseId,
                for: indexPath
            ) as? ShimmerPosterCell else { return UITableViewCell() }
            return cell
        }
    }
}

// MARK: - DetailViewController + UITableViewDelegate

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
