// IdentifireSaver.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Класс для схранения идентификатора фильма в userDefaults
final class IdentifireSaver {
    // MARK: - Constants

    static let shared = IdentifireSaver()

    private enum Constants {
        static let userDefaultsKey = "saveIds"
    }

    private(set) var savedIds: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: Constants.userDefaultsKey) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.userDefaultsKey)
        }
    }

    // MARK: - Initializators

    private init() {}

    func saveId(id: String) {
        var ids = savedIds
        ids.append(id)
        savedIds = ids
    }

    func remove(id: String) {
        var ids = savedIds
        if let index = ids.firstIndex(of: id) {
            ids.remove(at: index)
            savedIds = ids
        }
    }
}
