// MovieAPIService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MovieAPIServiceProtocol {
    func getDecodable<T: Decodable>(
        urlString: String,
        to decode: T.Type,
        completion: @escaping ResultHandler<T>
    )
}

final class MovieAPIService: MovieAPIServiceProtocol {
    // MARK: - Private  Properties

    private let session = URLSession.shared
    private let jsonDecoder = JSONDecoder()

    // MARK: - Public Methods

    func getDecodable<T>(
        urlString: String,
        to decode: T.Type,
        completion: @escaping ResultHandler<T>
    ) where T: Decodable {
        guard let url = URL(string: urlString) else {
            completion(.success(nil))
            return
        }

        session.dataTask(with: url) { data, _, error in
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
                let page = try? self.jsonDecoder.decode(T.self, from: data)
            else {
                result = .success(nil)
                return
            }

            result = .success(page)
        }.resume()
    }

    func downloadImage(url: URL, completion: @escaping (Result<Data?, Error>) -> ()) {
        session.dataTask(with: url) { data, _, error in
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
