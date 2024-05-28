// MoviesViewModel.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Простокол вьюМодели экрана фильмов
protocol MoviesViewModelProtocol: AnyObject {
    /// Получить фильмы из сети
    func getMovies()
    /// Состояние загрузки
    var loadingState: ((LoadingState<[Movie]>) -> ())? { get set }
    /// Метод для загрузки постера фильма
    func getImage(url: String, handler: @escaping (UIImage?) -> ())
    /// Переход на экран деталей
    func goToDetailsScreen(movieId: String)
}

/// ВьюМодель экрана фильмов
final class MoviesViewModel {
    // MARK: - Private property

    private weak var coordinator: MoviesCoordinator?
    private var networkService: NetworkServiceProtocol

    // MARK: - Public property

    var loadingState: ((LoadingState<[Movie]>) -> ())?

    // MARK: - Initializators

    init(
        coordinator: MoviesCoordinator?,
        networkService: NetworkServiceProtocol
    ) {
        self.coordinator = coordinator
        self.networkService = networkService
        loadingState?(.initial)
        getMovies()
    }
}

// MARK: - MoviesViewModel + MoviesViewModelProtocol

extension MoviesViewModel: MoviesViewModelProtocol {
    func goToDetailsScreen(movieId: String) {
        coordinator?.showDetailScreen(movieId: movieId)
    }

    func getImage(url: String, handler: @escaping (UIImage?) -> ()) {
        networkService.getImage(url: url) { image in
            handler(image)
        }
    }

    func getMovies() {
        let storage = StorageService.shared.fetchMovies()
        if storage.isEmpty {
            loadingState?(.loading)
            networkService.getMovies { [weak self] data in
                switch data {
                case .none:
                    self?.loadingState?(.failure)
                case let .some(data):
                    StorageService.shared.createMoviesData(movies: data)
                    DispatchQueue.main.async {
                        self?.loadingState?(.sucsess(data))
                    }
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.loadingState?(.sucsess(storage))
            }
        }
    }
}
