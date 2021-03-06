// MovieAPIService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

final class MovieAPIService: MovieAPIServiceProtocol {
    // MARK: - Public Methods

    func getDecodable<T>(
        urlString: String,
        to decode: T.Type,
        completion: @escaping ResultHandler<T?>
    ) where T: Decodable {
        guard let url = URL(string: urlString) else {
            completion(.success(nil))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            var result: Result<T?, Error>

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            if let error = error {
                result = .failure(error)
                return
            }

            guard
                let data = data,
                let page = try? JSONDecoder().decode(T.self, from: data)
            else {
                result = .success(nil)
                return
            }

            result = .success(page)
        }.resume()
    }
}
