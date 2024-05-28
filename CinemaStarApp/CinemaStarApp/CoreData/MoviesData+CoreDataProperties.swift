// MoviesData+CoreDataProperties.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

/// Расширение класса для сохранения фильмов
public extension MoviesData {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MoviesData> {
        NSFetchRequest<MoviesData>(entityName: "MoviesData")
    }

    @NSManaged var name: String?
    @NSManaged var image: String?
    @NSManaged var id: String?
    @NSManaged var rating: Double
}
