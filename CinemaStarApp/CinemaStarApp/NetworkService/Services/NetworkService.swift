// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import KeychainSwift
import UIKit
import Combine

final class Target {
    static var isMokeTarget: Bool {
        #if Mock
        true
        #else
        false
        #endif
    }
}

protocol NetworkProtocol {
    func fetchMovies() -> AnyPublisher<[Movie], Error>

    func fetchDetail(id: Int) -> AnyPublisher<MovieDetail, Error>
    
    func fetchImage(url: URL) -> AnyPublisher<Data, Never>
}

final class NetworkService: NetworkProtocol {
    private let apiResource = QuestionResourse()

    private var cancalables: Set<AnyCancellable> = []
    
    private var image = UIImage()

    func fetchMovies() -> AnyPublisher<[Movie], Error> {
        if Target.isMokeTarget {
        var fileName = "Movies"
            if fileName.isEmpty {
                fileName = fileName.replacingOccurrences(of: "/", with: "_")
            }
            let bundleURL = Bundle.main.url(forResource: fileName, withExtension: "json")
            guard let bundleURL else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            return URLSession.shared.dataTaskPublisher(for: bundleURL)
                .map(\.data)
                .decode(type: WelcomeDto.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .map { $0.docs.map { Movie(dto: $0) } }
                .eraseToAnyPublisher()
        } else {
            apiResource.queryItems = [URLQueryItem(name: "query", value: "История")]
            guard let url = apiResource.url else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            var request = URLRequest(url: url)
            print(request)
            let keychain = KeychainSwift()
            request.setValue(keychain.get("X-API-KEY"), forHTTPHeaderField: "X-API-KEY")
            return URLSession.shared.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: WelcomeDto.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .map { $0.docs.map { Movie(dto: $0) } }
                .eraseToAnyPublisher()
        }
    }

    func fetchDetail(id: Int) -> AnyPublisher<MovieDetail, Error> {
        apiResource.id = id
        guard let url = apiResource.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        let keychain = KeychainSwift()
        request.setValue(keychain.get("X-API-KEY"), forHTTPHeaderField: "X-API-KEY")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: DetailMovieDto.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .map { MovieDetail(dto: $0) }
            .eraseToAnyPublisher()
    }
    
    func fetchImage(url: URL) -> AnyPublisher<Data, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: RunLoop.main)
            .replaceError(with: image.pngData() ?? Data())
            .eraseToAnyPublisher()
    }
}
