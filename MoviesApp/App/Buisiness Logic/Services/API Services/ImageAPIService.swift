// ImageAPIService.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol ImageAPIServiceProtocol {
    func loadImage(by path: String, completion: @escaping ResultHandler<Data?>)
}

final class ImageAPIService: ImageAPIServiceProtocol {
    func loadImage(by path: String, completion: @escaping ResultHandler<Data?>) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "image.tmdb.org"
        urlComponents.path = "/t/p/w500\(path)"
        do {
            guard let url = urlComponents.url else { return }
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
                completion(.success(data))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
