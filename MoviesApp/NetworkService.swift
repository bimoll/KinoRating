// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

final class NetworkService {
    // MARK: - Private  Properties

    private let session = URLSession.shared
    private let jsonDecoder = JSONDecoder()

    // MARK: - Public Methods

    func getMoviesPage(
        urlString: String,
        comletion: @escaping (Result<MoviesListPage?, Error>) -> ()
    ) {
        guard let url = URL(string: urlString) else {
            comletion(.success(nil))
            return
        }

        session.dataTask(with: url) { data, _, error in
            var result: Result<MoviesListPage?, Error>

            defer {
                DispatchQueue.main.async {
                    comletion(result)
                }
            }

            if let error = error {
                result = .failure(error)
                return
            }

            guard
                let data = data,
                let page = try? self.jsonDecoder.decode(MoviesListPage.self, from: data)
            else {
                result = .success(nil)
                return
            }

            result = .success(page)
        }.resume()
    }

    func getMoviesInfo(urlString: String, comletion: @escaping (Result<MovieInfo?, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            comletion(.success(nil))
            return
        }

        session.dataTask(with: url) { data, _, error in
            var result: Result<MovieInfo?, Error>

            defer {
                DispatchQueue.main.async {
                    comletion(result)
                }
            }

            if let error = error {
                result = .failure(error)
                return
            }

            guard
                let data = data,
                let json = try? self.jsonDecoder.decode(MovieInfo.self, from: data)
            else {
                result = .success(nil)
                return
            }

            result = .success(json)
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
