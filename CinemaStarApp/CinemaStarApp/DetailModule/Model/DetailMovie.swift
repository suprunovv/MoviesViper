// DetailMovie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Детальное описание фильма
struct MovieDetail {
    /// url постера
    let posterUrl: String
    /// Название
    let name: String
    /// Рейтинг
    let rating: Double
    /// Описание
    let deskription: String
    /// Год выхода
    let year: Int
    /// Страна выпуска
    let country: String
    /// Тип (сериал/фильм)
    let type: String
    /// Актеры
    let actors: [Actor]
    /// Смотрите так же
    let semilarMovies: [SimilarMovie]?
    /// Язык фильма
    let language: String?

    init(dto: DetailMovieDto) {
        posterUrl = dto.poster?.url ?? ""
        name = dto.name ?? ""
        rating = round((dto.rating?.kp ?? 0) * 10) / 10
        deskription = dto.description ?? ""
        year = dto.year ?? 0
        country = dto.countries?.first?.name ?? ""
        type = dto.type == "movie" ? "Фильм" : "Сериал"
        actors = dto.persons?.compactMap { Actor(dto: $0) }.filter { !$0.name.isEmpty } ?? []
        semilarMovies = dto.similarMovies?.map { SimilarMovie(dto: $0) }
        language = dto.spokenLanguages?.first?.name
    }

    init?(data: DetailMoviesData) {
        guard let actors = try? JSONDecoder().decode([Actor].self, from: data.actors ?? Data()),
              let similars = try? JSONDecoder().decode(
                  [SimilarMovie].self,
                  from: data.similarMovies ?? Data()
              ) else { return nil }
        posterUrl = data.posterUrl ?? ""
        name = data.name ?? ""
        rating = data.rating
        deskription = data.descriptions ?? ""
        year = Int(data.year)
        country = data.country ?? ""
        type = data.type ?? ""
        self.actors = actors
        semilarMovies = similars
        language = data.language ?? ""
    }
}
