// ImageRequest.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Класс для получения картинки по url
final class ImageRequest: NetworkRequestProtocol {
    typealias ModelType = UIImage
    var url: URL?

    func decode(data: Data) -> ModelType? {
        UIImage(data: data)
    }

    func execute(completion: @escaping (UIImage?) -> ()) {
        guard let url else { return }
        load(url: url, completion: completion)
    }
}
