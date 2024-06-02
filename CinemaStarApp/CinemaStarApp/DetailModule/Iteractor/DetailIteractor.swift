
import Foundation
import Combine

protocol DetailViewIeractorProtocol {
    func getDetails(id: Int, complition: @escaping (MovieDetail) -> ())
    func getImage(url: String) -> AnyPublisher<Data, Never>
    var state: ((LoadingState) -> ())? { get set }
}

final class DetailViewIteractor: DetailViewIeractorProtocol {
    
    private var networkService: NetworkProtocol
    private var cancellables: Set<AnyCancellable> = []
    var state: ((LoadingState) -> ())?
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
    
    func getDetails(id: Int, complition: @escaping (MovieDetail) -> ()) {
        state?(.loading)
        let group = DispatchGroup()
            var details: MovieDetail?
            let detailsData = StorageService.shared.fetchDetailMovie(id: "\(id)")
            
            if let detailsData = detailsData {
                complition(detailsData)
            } else {
                networkService.fetchDetail(id: id)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            self.state?(.failure(error))
                        case .finished:
                            break
                        }
                    } receiveValue: { [unowned self] result in
                        details = result
                        group.enter()
                        details?.actors.enumerated().forEach { index, actorr in
                            group.enter()
                            self.getImage(url: actorr.photoUrl)
                                .sink { imageData in
                                    details?.actors[index].imageData = imageData
                                    group.leave()
                                }
                                .store(in: &self.cancellables)
                        }
                        
                        details?.semilarMovies?.enumerated().forEach { index, movie in
                            group.enter()
                            self.getImage(url: movie.posterUrl)
                                .sink { data in
                                    details?.semilarMovies?[index].imageData = data
                                    group.leave()
                                }
                                .store(in: &self.cancellables)
                        }
                        
                        if let posterUrl = details?.posterUrl {
                            group.enter()
                            self.getImage(url: posterUrl)
                                .sink { data in
                                    details?.imageData = data
                                    group.leave()
                                }
                                .store(in: &self.cancellables)
                        }
                        group.leave()
                        group.notify(queue: .main) {
                            if let details = details {
                                StorageService.shared.createDetailMovieData(movie: details, id: "\(id)")
                                self.state?(.sucsess)
                                complition(details)
                            }
                        }
                    }
                    .store(in: &cancellables)
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
