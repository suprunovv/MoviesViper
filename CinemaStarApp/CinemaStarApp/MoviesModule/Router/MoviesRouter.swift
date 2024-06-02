// MoviesRouter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import SwiftUI

typealias StartPoint = UIViewController

protocol MoviesRouterProtocol {
    var entry: StartPoint? { get set }

    static func createMoviesModule() -> MoviesRouterProtocol
    
    func goToDetails(movieId: Int)
}

final class MoviesRouter: MoviesRouterProtocol {
    var entry: StartPoint?
    static func createMoviesModule() -> MoviesRouterProtocol {
        let router = MoviesRouter()
        let networkService = NetworkService()
        let iteractor = MoviesIterator(networkService: networkService)
        let presenter = MoviesViewPresenter(iteractor: iteractor, router: router)
        let view = MoviesView(presenter: presenter)
        let chaildView = UIHostingController(rootView: view)
        router.entry = chaildView
        return router
    }
    
    func goToDetails(movieId: Int) {
        let detailView = DetailRouter.createDetailModule(movieId: movieId)
        guard let view = detailView.entry else { return }
        entry?.navigationController?.pushViewController(view, animated: true)
    }
}
