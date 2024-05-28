// CoordinatorProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол координатора
protocol CoordinatorProtocol: AnyObject {
    /// Дочерние координаторы
    var childCoordinators: [CoordinatorProtocol] { get set }
    /// Старт флоу
    func start()
}

extension CoordinatorProtocol {
    /// Добавление дочерних координаторов
    func add(coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }

    /// Удаление дочернего координатора
    func remove(coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
