// MoviesViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Combine
import SwiftUI

/// Простокол вьюМодели экрана фильмов
protocol MoviesViewPresenterProtocol: ObservableObject {
    /// Получить фильмы из сети
    func getMovies()
    /// Массив фильмов
    var movies: [Movie] { get set }
}

/// ВьюМодель экрана фильмов
final class MoviesViewPresenter: MoviesViewPresenterProtocol {
    // MARK: - Private property
    private var cancalables: Set<AnyCancellable> = []

    private var iteractor: MoviesIteractorProtocol?
    private var router: MoviesRouterProtocol?

    // MARK: - Public property
    
    @Published var movies: [Movie] = []
    @Published var state: LoadingState = .initial

    // MARK: - Initializators

    init(
        iteractor: MoviesIteractorProtocol,
        router: MoviesRouterProtocol
    ) {
        self.iteractor = iteractor
        self.router = router
        updateState()
        getMovies()
    }

    func updateState() {
        iteractor?.state = { [weak self] result in
            self?.state = result
        }
    }
    func getMovies() {
        iteractor?.getMovies() { movies in
            self.movies = movies
        }
    }
    
    func goToDetails(id: Int) {
        router?.goToDetails(movieId: id)
    }
    
    
}
