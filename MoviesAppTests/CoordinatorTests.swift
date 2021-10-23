// CoordinatorTests.swift
// Copyright © RoadMap. All rights reserved.

@testable import MoviesApp
import XCTest

final class CoordinatorTests: XCTestCase {
    var coordinator: ApplicationCoordinator!
    var mockNavigationController: MockNavigationController!

    override func setUpWithError() throws {
        mockNavigationController = MockNavigationController()
        coordinator = ApplicationCoordinator(assembly: Assembly(), navigationController: mockNavigationController)
    }

    override func tearDownWithError() throws {
        mockNavigationController = nil
        coordinator = nil
    }

    func testValidPresentationMovieList() {
        coordinator.start()
        XCTAssertTrue(mockNavigationController.presentedVC is MoviesListViewController)
    }

    func testValidPresentationDetailMovies() {
        coordinator.start()
        guard let moviesListVC = mockNavigationController.presentedVC as? MoviesListViewController else { return }
        moviesListVC.toMovieDetail?(2)
        XCTAssertTrue(mockNavigationController.presentedVC is MovieDetailViewController)
    }
}
