// DocDto.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Дто для получения данных о филмах
struct DocDto: Codable {
    /// Название фильма
    let name: String
    /// Постер фильма
    let poster: PosterDto
    /// Рейтинги
    let rating: RatingDto
    /// Идентификатор
    let id: Int
}

/// Дто для получения постера
struct PosterDto: Codable {
    /// url постера
    let url: String
}

/// Дто для получения рейтинга
struct RatingDto: Codable {
    /// Рейтинг кинопоиска
    let kp: Double
}
