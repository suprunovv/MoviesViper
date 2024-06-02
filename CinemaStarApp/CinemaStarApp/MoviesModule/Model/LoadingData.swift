// LoadingData.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Стейт загрузки фильмов
enum LoadingState {
    /// Инициализация
    case initial
    /// Загрузка
    case loading
    /// Успешная загрузка и получение данных
    case sucsess
    /// Ошибка загрузки
    case failure(Error)
}
