// CacheServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol CacheServiceProtocol {
    func saveToCache(path: String, data: Data)
    func getCachedData(path: String) -> Data?
}
