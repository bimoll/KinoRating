// CacheImageService.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol CacheImageServiceProtocol {
    func saveImageToCache(path: String, image: UIImage)
    func getCachedImage(path: String) -> UIImage?
}

final class CacheImageService: CacheImageServiceProtocol {
    // MARK: - Private Properties

    private let fileManager = FileManager.default

    private lazy var pathName: String = {
        let pathName = "images"
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return pathName }
        let url = cacheDir.appendingPathComponent(pathName, isDirectory: true)

        if !fileManager.fileExists(atPath: url.path) {
            try? fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }

        return pathName
    }()

    // MARK: - Public Methods

    func saveImageToCache(path: String, image: UIImage) {
        guard let filePath = getFilePath(path: path) else { return }

        let date = image.pngData()

        fileManager.createFile(atPath: filePath, contents: date, attributes: nil)
    }

    func getCachedImage(path: String) -> UIImage? {
        guard let fileName = getFilePath(path: path) else { return nil }
        return UIImage(contentsOfFile: fileName)
    }

    // MARK: - Private Methods

    private func getFilePath(path: String) -> String? {
        guard let cachedDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return nil }
        let imageHash = path.split(separator: "/").last ?? "default"
        return cachedDirectory.appendingPathComponent(pathName + "/" + imageHash).path
    }
}
