// ApiRequest.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import KeychainSwift

/// Протокол запроса
protocol NetworkRequestProtocol: AnyObject {
    /// Тип модели
    associatedtype ModelType
    /// Метод для декодирования типа Data в нужный тип
    func decode(data: Data) -> ModelType?
    /// Метод для запроса
    func execute(completion: @escaping (ModelType?) -> ())
}

/// Расширение протокола запроса
extension NetworkRequestProtocol {
    func load(url: URL, completion: @escaping (ModelType?) -> ()) {
        var request = URLRequest(url: url)
        let keychain = KeychainSwift()
        request.setValue(keychain.get("X-API-KEY"), forHTTPHeaderField: "X-API-KEY")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let data else { return }
            guard let value = self?.decode(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(value)
            }
        }
        task.resume()
    }
}

/// Класс для получения данных из сети
final class APIRequest<Resourse: APIResource>: NetworkRequestProtocol {
    typealias ModelType = Resourse.ModelType
    let resourse: Resourse

    init(resourse: Resourse) {
        self.resourse = resourse
    }

    func decode(data: Data) -> ModelType? {
        let decoder = JSONDecoder()
        let wrapper = try? decoder.decode(ModelType.self, from: data)
        return wrapper
    }

    func execute(completion: @escaping (Resourse.ModelType?) -> ()) {
        guard let url = resourse.url else { return }
        load(url: url, completion: completion)
    }
}
