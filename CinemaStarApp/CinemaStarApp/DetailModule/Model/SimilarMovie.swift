// SimilarMovie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Рекомендованный фильм
struct SimilarMovie: Codable {
    /// Название
    let name: String
    /// url постера
    let posterUrl: String

    init(dto: SimilarMoviesDto) {
        name = dto.name
        posterUrl = dto.poster.url
    }
}
