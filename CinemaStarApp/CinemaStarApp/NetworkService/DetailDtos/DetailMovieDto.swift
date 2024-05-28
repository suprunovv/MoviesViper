// DetailMovieDto.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Дто для получения детального описания фильма
struct DetailMovieDto: Codable {
    let poster: PosterDto?
    let name: String?
    let rating: RatingDto?
    let description: String?
    let year: Int?
    let countries: [CoutriesDto]?
    let type: String?
    let persons: [ActorDto]?
    let spokenLanguages: [SpocenLanguage]?
    let similarMovies: [SimilarMoviesDto]?
}

/// Дто для получения языка
struct SpocenLanguage: Codable {
    /// Название языка
    let name: String
}

/// Дто для поучения Страны выпуска фильма
struct CoutriesDto: Codable {
    /// Название страны
    let name: String
}
