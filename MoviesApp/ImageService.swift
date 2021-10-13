// ImageService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

final class ImageAPIService {
    func downloadImage(url: URL, completion: @escaping (Result<Data?, Error>) -> ()) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            var result: Result<Data?, Error>

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            if let error = error {
                result = .failure(error)
                return
            }

            guard let data = data else {
                result = .success(nil)
                return
            }
            result = .success(data)
        }.resume()
    }
}
