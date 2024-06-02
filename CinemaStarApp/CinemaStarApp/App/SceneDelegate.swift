// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import Combine
import SwiftUI
import UIKit

///
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

//    let network = NetworkTest<WelcomeDto>()
//    let test = NetworkTest<DetailMovieDto>()
//    var cancel: Set<AnyCancellable> = []

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupWindow(withScene: scene)
    }

    private func setupWindow(withScene scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let router = MoviesRouter.createMoviesModule()
        guard let view = router.entry else { return }
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.isNavigationBarHidden = true
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
