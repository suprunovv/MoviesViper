// MoviesIteractor.swift
// Copyright © RoadMap. All rights reserved.

import Combine
import Foundation

protocol MoviesIteractorProtocol {
    func getMovies(complition: @escaping (([Movie]) -> ()))
    func getImage(url: String) -> AnyPublisher<Data, Never>
    var state: ((LoadingState) -> ())? { get set }
}

final class MoviesIterator: MoviesIteractorProtocol {
    private var networkService: NetworkProtocol
    
    private var cancelables: Set<AnyCancellable> = []
    
    var state: ((LoadingState) -> ())?

    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
    func getMovies(complition: @escaping (([Movie]) -> ())) {
        state?(.loading)
        let moviesData = StorageService.shared.fetchMovies()
           var movies: [Movie] = []
           let group = DispatchGroup()
           if moviesData.isEmpty {
               networkService.fetchMovies()
                   .sink { cancal in
                       switch cancal {
                       case .failure(let error):
                           self.state?(.failure(error))
                       case .finished:
                           break
                       }
                   } receiveValue: { result in
                       movies = result
                       result.enumerated().forEach { index, movie in
                           group.enter()
                           self.getImage(url: movie.image)
                               .sink(receiveValue: { imageData in
                                   movies[index].imageData = imageData
                                   group.leave()
                               })
                               .store(in: &self.cancelables)
                       }
                       group.notify(queue: .main) {
                           StorageService.shared.createMoviesData(movies: movies)
                           complition(movies)
                           self.state?(.sucsess)
                       }
                   }
                   .store(in: &cancelables)

           } else {
               complition(moviesData)
               self.state?(.sucsess)
           }
    }

    func getImage(url: String) -> AnyPublisher<Data, Never> {
        guard let url = URL(string: url) else {
            return Just(Data())
                .eraseToAnyPublisher()
        }
        return networkService.fetchImage(url: url)
    }
    
}
