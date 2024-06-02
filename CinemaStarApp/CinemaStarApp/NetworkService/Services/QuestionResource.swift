// QuestionResource.swift
// Copyright © RoadMap. All rights reserved.


import Foundation

/// Протокол ресурса
protocol APIResource {
    /// Путь
    var methodPath: String { get }
    /// Элементы запроса
    var queryItems: [URLQueryItem]? { get set }
}

/// Расширение протокола ресурса
extension APIResource {
    var url: URL? {
        var components = URLComponents(string: "https://api.kinopoisk.dev")
        components?.path = methodPath
        components?.queryItems = queryItems
        return components?.url
    }
}

/// Ресурс
final class QuestionResourse: APIResource {
    var queryItems: [URLQueryItem]?
    var id: Int?
    var methodPath: String {
        guard let id else {
            return "/v1.4/movie/search"
        }
        return "/v1.4/movie/\(id)"
    }
}

