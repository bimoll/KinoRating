// CacheServiceTest.swift
// Copyright © RoadMap. All rights reserved.

@testable import MoviesApp
import XCTest

final class CacheServiceTest: XCTestCase {
    var cacheService: CacheService!
    let imageData = UIImage(named: "moviePlaceholder")?.pngData()

    override func setUpWithError() throws {
        cacheService = CacheService(directoryName: "testDirectory")
    }

    override func tearDownWithError() throws {
        cacheService = nil
    }

    func testCaching() {
        cacheService.saveToCache(path: "test", data: imageData ?? Data())
        let data = cacheService.getCachedData(path: "test")
        XCTAssertEqual(data, imageData)
    }
}
