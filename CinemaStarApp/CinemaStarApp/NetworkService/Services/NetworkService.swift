// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import KeychainSwift
import UIKit

/// Протокол для нетворк сервиса
protocol NetworkServiceProtocol {
    /// Метод для загрузки фильмов
    func getMovies(handler: @escaping ([Movie]?) -> ())
    /// Метод для загрузки деталей фильма
    func getDetails(id: Int, handler: @escaping (MovieDetail?) -> ())
    /// Метод для загрузки изображения
    func getImage(url: String, handler: @escaping (UIImage?) -> ())
}

/// Нетворк сервис
final class NetworkService<D: Decodable>: NetworkServiceProtocol {
    // MARK: - Private property

    private let apiResurce = QuestionResourse<D>()
    private lazy var apiRequest = APIRequest(resourse: apiResurce)
    private let imageLoder = ImageRequest()

    // MARK: - Public methods

    func getMovies(handler: @escaping ([Movie]?) -> ()) {
        apiResurce.queryItems = [URLQueryItem(name: "query", value: "История")]
        apiRequest.execute { result in
            switch result {
            case let .some(dto):
                guard let moviesDto = dto as? WelcomeDto else {
                    handler(nil)
                    return
                }
                handler(moviesDto.docs.compactMap { Movie(dto: $0) })
            case .none:
                handler(nil)
            }
        }
    }

    func getDetails(id: Int, handler: @escaping (MovieDetail?) -> ()) {
        apiResurce.id = id
        apiRequest.execute { result in
            switch result {
            case let .some(dto):
                guard let detailDto = dto as? DetailMovieDto else {
                    handler(nil)
                    return
                }
                handler(MovieDetail(dto: detailDto))
            case .none:
                handler(nil)
            }
        }
    }

    func getImage(url: String, handler: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: url) else { return }
        imageLoder.url = url
        imageLoder.execute { image in
            switch image {
            case .none:
                handler(nil)
            case let .some(image):
                handler(image)
            }
        }
    }
}
