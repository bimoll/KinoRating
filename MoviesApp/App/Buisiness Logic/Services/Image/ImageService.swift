// ImageService.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol ImageServiceProtocol {
    var downloadNotify: VoidHandler? { get set }
    func getPhoto(path: String, completionHandler: @escaping ImageHandler)
}

final class ImageService: ImageServiceProtocol {
    // MARK: - Public Properties

    var downloadNotify: VoidHandler?

    // MARK: - Private Properties

    private let cacheImageService = CacheImageService()

    // MARK: - Public Methods

    func getPhoto(path: String, completionHandler: @escaping ImageHandler) {
        if let image = cacheImageService.getCachedImage(path: path) {
            completionHandler(image)
        } else {
            downloadNotify?()
            DispatchQueue.global().async {
                self.loadPhoto(by: path, completionHandler: completionHandler)
            }
        }
    }

    // MARK: - Private Methods

    private func loadPhoto(by path: String, completionHandler: @escaping ImageHandler) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "image.tmdb.org"
        urlComponents.path = "/t/p/w500\(path)"
        guard let url = urlComponents.url,
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data)
        else {
            DispatchQueue.main.async {
                completionHandler(nil)
            }
            return
        }

        cacheImageService.saveImageToCache(path: path, image: image)

        DispatchQueue.main.async {
            completionHandler(image)
        }
    }
}
