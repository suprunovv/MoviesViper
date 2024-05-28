// BaseCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Базовый координатор
class BaseCoordinator: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []

    func start() {
        fatalError("Метод старт, должен быть переопределен!")
    }

    func setAsRoot(_ controller: UIViewController) {
        let window = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .last { $0.isKeyWindow }
        window?.rootViewController = controller
    }
}
