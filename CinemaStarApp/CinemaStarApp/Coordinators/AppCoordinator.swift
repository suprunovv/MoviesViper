// AppCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Координатор приложения
final class AppCoordinator: BaseCoordinator {
    override func start() {
        toMain()
    }

    func toMain() {
        let moviesCoordinator = MoviesCoordinator()
        add(coordinator: moviesCoordinator)
        moviesCoordinator.start()
    }
}
