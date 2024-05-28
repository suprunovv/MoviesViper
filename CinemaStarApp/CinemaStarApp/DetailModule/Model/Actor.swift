// Actor.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Данные актера
struct Actor: Codable {
    /// url Фото актера
    let photoUrl: String
    /// Имя Фамилия актера
    let name: String

    init(dto: ActorDto) {
        photoUrl = dto.photo ?? ""
        name = dto.name ?? ""
    }
}
