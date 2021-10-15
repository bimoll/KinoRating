// ImageService.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol ImageServiceProtocol {
    func getImageData(path: String, completion: @escaping ResultHandler<Data?>)
}

final class ImageService: ImageServiceProtocol {
    // MARK: - Public Properties

    var downloadNotify: VoidHandler?

    // MARK: - Private Properties

    private let imageAPIService = ImageAPIService()
    private let cacheImageService = CacheService(directoryName: GlobalConstants.imagesDirectoryName)
    private lazy var imageAPIServiceProxy = ImageAPIServiceProxy(
        cacheService: cacheImageService,
        imageAPIService: imageAPIService
    )

    // MARK: - Public Methods

    func getImageData(path: String, completion: @escaping ResultHandler<Data?>) {
        imageAPIServiceProxy.loadImage(by: path) { result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
