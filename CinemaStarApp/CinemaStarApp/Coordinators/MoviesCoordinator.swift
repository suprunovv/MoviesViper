// MoviesCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

/// Координатор флоу фильмов
final class MoviesCoordinator: BaseCoordinator {
    var navigationController: UINavigationController?

    override func start() {
        guard let moviesModule = ModuleBuilder.makeMoviesModule(coordinator: self) as? MoviesViewController
        else { return }
        navigationController = UINavigationController(rootViewController: moviesModule)
        if let navigationController = navigationController {
            setAsRoot(navigationController)
        }
    }

    func showDetailScreen(movieId: String) {
        guard let detailModule = ModuleBuilder.makeDetailModule(
            coordinator: self,
            movieId: movieId
        ) as? DetailViewController else { return }
        navigationController?.pushViewController(detailModule, animated: true)
    }

    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
