// StorageService.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

/// Сервис для работы с кор дата
final class StorageService {
    // MARK: - Constants

    enum Constants {
        static let movieData = "MoviesData"
        static let detailMovieData = "DetailMoviesData"
        static let coreData = "CoreData"
    }

    static let shared = StorageService()

    // MARK: - initializators

    private init() {}

    // MARK: - Private properties

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.coreData)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()

    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Private methods

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print(error.localizedDescription)
            }
        }
    }

    func createMoviesData(movies: [Movie]) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: Constants.movieData, in: context)
        else { return }
        for movie in movies {
            let movieData = MoviesData(entity: entityDescription, insertInto: context)
            movieData.image = movie.image
            movieData.id = movie.id
            movieData.name = movie.name
            movieData.rating = movie.rating
        }
        saveContext()
    }

    func createDetailMovieData(movie: MovieDetail, id: String) {
        guard let entityDescription = NSEntityDescription.entity(
            forEntityName: Constants.detailMovieData,
            in:
            context
        ) else { return }
        let detailMovie = DetailMoviesData(entity: entityDescription, insertInto: context)
        detailMovie.name = movie.name
        detailMovie.rating = movie.rating
        detailMovie.descriptions = movie.deskription
        detailMovie.year = Int16(movie.year)
        detailMovie.country = movie.country
        detailMovie.type = movie.type
        detailMovie.posterUrl = movie.posterUrl
        detailMovie.rating = movie.rating
        detailMovie.language = movie.language
        detailMovie.actors = try? JSONEncoder().encode(movie.actors)
        detailMovie.similarMovies = try? JSONEncoder().encode(movie.semilarMovies)
        detailMovie.movieId = id
        saveContext()
    }

    func fetchDetailMovie(id: String) -> MovieDetail? {
        do {
            guard let result = try? context.fetch(DetailMoviesData.fetchRequest()) else { return nil }
            guard let movie = result.first(where: { $0.movieId == id }) else { return nil }
            return MovieDetail(data: movie)
        }
    }

    func fetchMovies() -> [Movie] {
        do {
            guard let result = try? context.fetch(MoviesData.fetchRequest()) else { return [] }
            let movies = result.compactMap { Movie(data: $0) }
            return movies
        }
    }
}
