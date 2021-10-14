// CacheImageService.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class CacheImageService {
    // MARK: - Private Properties

    private let fileManager = FileManager.default

    private lazy var filePath: String = {
        let pathName = "images"
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return pathName }
        let url = cacheDirectory.appendingPathComponent(pathName, isDirectory: true)
        if !fileManager.fileExists(atPath: url.path) {
            try? fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }()

    // MARK: - Public Methods

    func saveImageToCache(url: String, image: UIImage) {
        guard
            let fileName = getFilePath(url: url),
            let imageData = image.pngData()
        else { return }
        fileManager.createFile(atPath: fileName, contents: imageData, attributes: nil)
    }

    func getImageFromCache(url: String) -> UIImage? {
        guard let fileName = getFilePath(url: url) else { return nil }
        return UIImage(contentsOfFile: fileName)
    }

    // MARK: - Private Methods

    private func getFilePath(url: String) -> String? {
        guard let cachedDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return nil }
        let imageHash = url.split(separator: "/").last ?? "default"
        return cachedDirectory.appendingPathComponent(filePath + "/" + imageHash).path
    }
}
