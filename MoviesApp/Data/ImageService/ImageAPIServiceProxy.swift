// ImageAPIServiceProxy.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

final class ImageAPIServiceProxy: ImageAPIServiceProtocol {
    // MARK: - Private Properties

    private let cacheService: CacheServiceProtocol
    private let imageAPIService: ImageAPIServiceProtocol

    // MARK: - Initialization

    init(cacheService: CacheServiceProtocol, imageAPIService: ImageAPIServiceProtocol) {
        self.cacheService = cacheService
        self.imageAPIService = imageAPIService
    }

    // MARK: - Public Properties

    func loadImage(by path: String, completion: @escaping ResultHandler<Data?>) {
        if let data = cacheService.getCachedData(path: path) {
            completion(.success(data))
        } else {
            DispatchQueue.global().async {
                self.imageAPIService.loadImage(by: path) { [weak self] data in
                    guard let self = self else { return }

                    switch data {
                    case let .success(data):
                        guard let cahcedData = data else { return }
                        self.cacheService.saveToCache(path: path, data: cahcedData)
                        completion(.success(data))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
