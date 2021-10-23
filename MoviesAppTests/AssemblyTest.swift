// AssemblyTest.swift
// Copyright © RoadMap. All rights reserved.

@testable import MoviesApp
import XCTest

final class AssemblyTest: XCTestCase {
    var assembly: AssemblyProtocol!

    override func setUpWithError() throws {
        assembly = Assembly()
    }

    override func tearDownWithError() throws {
        assembly = nil
    }

    func testAssemblySuccess() throws {
        let movieListVC = assembly.createMovieListModule()
        XCTAssertTrue(movieListVC is MoviesListViewController)

        let movieDetailsVC = assembly.createDetailMoviesModule(0)
        XCTAssertTrue(movieDetailsVC is MovieDetailViewController)
    }
}
