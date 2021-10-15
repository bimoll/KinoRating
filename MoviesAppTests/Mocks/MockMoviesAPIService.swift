// MockMoviesAPIService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
@testable import MoviesApp

final class MockMoviesAPIService: MovieAPIServiceProtocol {
    func getDecodable<T>(
        urlString: String,
        to decode: T.Type,
        completion: @escaping ResultHandler<T?>
    ) where T: Decodable {
        urlString.isEmpty
            ? completion(.failure(CustomErrors.fetchedDataIsNil))
            : completion(.success(nil))
    }
}
