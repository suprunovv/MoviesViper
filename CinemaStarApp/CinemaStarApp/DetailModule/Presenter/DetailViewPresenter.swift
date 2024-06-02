// DetailViewModel.swift
// Copyright © RoadMap. All rights reserved.

import SwiftUI
import Combine

/// Вью модель детального экрана
 final class DetailViewPresenter {
    // MARK: - Private property

     private var movieId: String
     private var iteractor: DetailViewIeractorProtocol
     private var router: DetailRouterProtocol
     private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public property

     @Published var details: MovieDetail?
     @Published var isLike = false
     @Published var state: LoadingState = .initial

    // MARK: - Initializators

     init(movieId: String, iteractor: DetailViewIeractorProtocol, router: DetailRouterProtocol) {
         self.movieId = movieId
         self.iteractor = iteractor
         self.router = router
         getDetails()
         checkLike()
         updateState()
    }
     
    private func checkLike() {
         if IdentifireSaver.shared.savedIds.contains(movieId) {
             isLike = true
         } else {
             isLike = false
         }
     }
     
     func likeToggle() {
         if isLike {
             IdentifireSaver.shared.remove(id: movieId)
         } else {
             IdentifireSaver.shared.saveId(id: movieId)
         }
         isLike.toggle()
     }
     
     func updateState() {
         iteractor.state = { [weak self] result in
             self?.state = result
         }
     }
     
 }

extension DetailViewPresenter: ObservableObject {
    func goBack() {
        router.back()
    }
    
    func getDetails() {
        iteractor.getDetails(id: Int(movieId) ?? 0) { [weak self] details in
            self?.details = details
        }
    }
    
    func getPosterImage() {
        iteractor.getImage(url: details?.posterUrl ?? "")
            .sink { self.details?.imageData = $0 }
            .store(in: &cancellables)
    }
    
    func getActorsImages() {
        details?.actors.enumerated().forEach { index, actorr in
            iteractor.getImage(url: actorr.photoUrl)
                .sink { data in
                    self.details?.actors[index].imageData = data
                }
                .store(in: &cancellables)
        }
    }
    
    func getSemilarImages() {
        details?.semilarMovies?.enumerated().forEach { index, movie in
            iteractor.getImage(url: movie.posterUrl)
                .sink { data in
                    self.details?.semilarMovies?[index].imageData = data
                }
                .store(in: &cancellables)
        }
    }

 }
