// Movie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель фильма
struct Movie {
    /// Название картинки
    let image: String
    /// Название фильма
    let name: String
    /// Рейтинг фильма
    let rating: Double
    /// id фильма
    let id: String

    init(dto: DocDto) {
        image = dto.poster.url
        name = dto.name
        rating = round(dto.rating.kp * 10) / 10
        id = String(dto.id)
    }

    init(data: MoviesData) {
        image = data.image ?? ""
        name = data.name ?? ""
        rating = data.rating
        id = data.id ?? ""
    }
}
