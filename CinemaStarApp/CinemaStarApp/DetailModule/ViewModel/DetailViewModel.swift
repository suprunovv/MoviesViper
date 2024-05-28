// DetailViewModel.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Интерфейс вью модели детального экрана
protocol DetailViewModelProtocol: AnyObject {
    /// Замыкание для передачи состояния загрузки
    var loadingState: ((LoadingState<MovieDetail>) -> ())? { get set }
    /// Массив типой секций
    var sectionTypes: [SectionType] { get }
    /// Метод для получения картинки
    func getImage(url: String, handler: @escaping (UIImage?) -> ())
    /// Метод для закрытия экрана
    func closeDetailScreen()
    /// Замыкание для передачи состояния кнопки
    var favoriteState: ((FavoriteState) -> ())? { get set }
    /// Метод для добавления/удаления избранного
    func updateFavorite()
}

/// Вью модель детального экрана
final class DetailViewModel {
    // MARK: - Private property

    private var coordinator: MoviesCoordinator?
    private var movieId: String?
    private var networkService: NetworkServiceProtocol
    private let imageLoader = ImageRequest()

    // MARK: - Public property

    var sectionTypes: [SectionType] = [.poster, .description, .actors]
    var loadingState: ((LoadingState<MovieDetail>) -> ())?
    var favoriteState: ((FavoriteState) -> ())?

    // MARK: - Initializators

    init(coordinator: MoviesCoordinator?, movieId: String?, networkService: NetworkServiceProtocol) {
        self.coordinator = coordinator
        self.movieId = movieId
        self.networkService = networkService
        loadingState?(.loading)
        getDetails()
    }

    private func updateFavoriteState() {
        guard let movieId else { return }
        if IdentifireSaver.shared.savedIds.contains(movieId) {
            favoriteState?(.saved)
        } else {
            favoriteState?(.unsaved)
        }
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    func updateFavorite() {
        guard let movieId else { return }
        if IdentifireSaver.shared.savedIds.contains(movieId) {
            IdentifireSaver.shared.remove(id: movieId)
            DispatchQueue.main.async {
                self.favoriteState?(.unsaved)
            }
        } else {
            IdentifireSaver.shared.saveId(id: movieId)
            DispatchQueue.main.async {
                self.favoriteState?(.saved)
            }
        }
    }

    func getDetails() {
        guard let movieId else { return }
        let details = StorageService.shared.fetchDetailMovie(id: movieId)
        if let details {
            if details.semilarMovies != nil {
                sectionTypes.append(.recommendations)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.loadingState?(.sucsess(details))
            }
        } else {
            networkService.getDetails(id: Int(movieId) ?? 0) { [weak self] details in
                switch details {
                case .none:
                    self?.loadingState?(.failure)
                case let .some(data):
                    if data.semilarMovies != nil {
                        self?.sectionTypes.append(.recommendations)
                    }
                    self?.loadingState?(.sucsess(data))
                    StorageService.shared.createDetailMovieData(movie: data, id: movieId)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.updateFavoriteState()
        }
    }

    func getImage(url: String, handler: @escaping (UIImage?) -> ()) {
        networkService.getImage(url: url) { image in
            handler(image)
        }
    }

    func closeDetailScreen() {
        coordinator?.goBack()
    }
}
