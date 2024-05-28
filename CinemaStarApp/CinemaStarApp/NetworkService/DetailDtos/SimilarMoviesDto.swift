// SimilarMoviesDto.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Дто для рекомендованных фильмов
struct SimilarMoviesDto: Codable {
    /// Название
    let name: String
    /// Постер
    let poster: PosterDto
}
