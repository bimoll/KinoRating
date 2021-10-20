// ImageAPIService.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class ImageAPIService: ImageAPIServiceProtocol {
    private enum LocalConstants {
        static let scheme = "https"
        static let host = "image.tmdb.org"
        static let path = "/t/p/w500"
    }

    func loadImage(by path: String, completion: @escaping ResultHandler<Data?>) {
        var urlComponents = URLComponents()
        urlComponents.scheme = LocalConstants.scheme
        urlComponents.host = LocalConstants.host
        urlComponents.path = LocalConstants.path + path

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
