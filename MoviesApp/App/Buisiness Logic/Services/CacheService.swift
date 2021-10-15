// CacheService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol CacheServiceProtocol {
    func saveToCache(path: String, data: Data)
    func getCachedData(path: String) -> Data?
}

final class CacheService: CacheServiceProtocol {
    // MARK: - Private Properties

    private let fileManager = FileManager.default
    private let directoryName: String

    private lazy var pathName: String = {
        let pathName = directoryName
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return pathName }
        let url = cacheDir.appendingPathComponent(pathName, isDirectory: true)

        if !fileManager.fileExists(atPath: url.path) {
            try? fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }

        return pathName
    }()

    // MARK: - Initialization

    init(directoryName: String) {
        self.directoryName = directoryName
    }

    // MARK: - Public Methods

    func saveToCache(path: String, data: Data) {
        guard let filePath = getFilePath(path: path) else { return }
        fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
    }

    func getCachedData(path: String) -> Data? {
        guard let fileName = getFilePath(path: path) else { return nil }
        let url = URL(fileURLWithPath: fileName)
        return try? Data(contentsOf: url)
    }

    // MARK: - Private Methods

    private func getFilePath(path: String) -> String? {
        guard let cachedDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return nil }
        let imageHash = path.split(separator: "/").last ?? "default"
        return cachedDirectory.appendingPathComponent(pathName + "/" + imageHash).path
    }
}
