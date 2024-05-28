// DetailMoviesData+CoreDataProperties.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

/// Расширение класса для хранения деталей
public extension DetailMoviesData {
    @nonobjc class func fetchRequest() -> NSFetchRequest<DetailMoviesData> {
        NSFetchRequest<DetailMoviesData>(entityName: "DetailMoviesData")
    }

    @NSManaged var similarMovies: Data?
    @NSManaged var name: String?
    @NSManaged var rating: Double
    @NSManaged var descriptions: String?
    @NSManaged var year: Int16
    @NSManaged var country: String?
    @NSManaged var type: String?
    @NSManaged var actors: Data?
    @NSManaged var language: String?
    @NSManaged var posterUrl: String?
    @NSManaged var movieId: String?
}

extension DetailMoviesData: Identifiable {}
