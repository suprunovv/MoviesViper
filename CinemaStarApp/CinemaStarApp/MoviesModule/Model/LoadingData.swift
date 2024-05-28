// LoadingData.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Стейт загрузки фильмов
enum LoadingState<T> {
    /// Инициализация
    case initial
    /// Загрузка
    case loading
    /// Успешная загрузка и получение данных
    case sucsess(T)
    /// Ошибка загрузки
    case failure
}
