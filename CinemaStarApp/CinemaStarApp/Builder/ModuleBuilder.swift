// ModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Билдер модулей
final class ModuleBuilder {
    /// Модуль экрана с фильмами
    static func makeMoviesModule(coordinator: MoviesCoordinator) -> UIViewController {
        let viewController = MoviesViewController()
        let networkService = NetworkService<WelcomeDto>()
        let viewModel = MoviesViewModel(
            coordinator: coordinator,
            networkService: networkService
        )
        viewController.viewModel = viewModel
        return viewController
    }

    /// Модуль экрана с детальным описанием фильма
    static func makeDetailModule(coordinator: MoviesCoordinator, movieId: String) -> UIViewController {
        let viewController = DetailViewController()
        let networkService = NetworkService<DetailMovieDto>()
        let viewModel = DetailViewModel(
            coordinator: coordinator,
            movieId: movieId,
            networkService: networkService
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
