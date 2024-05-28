// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

///
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupWindow(withScene: scene)
    }

    private func setupWindow(withScene scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator()
        appCoordinator?.start()
    }
}
