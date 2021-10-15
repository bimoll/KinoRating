// MovieListViewModelTest.swift
// Copyright © RoadMap. All rights reserved.

@testable import MoviesApp
import XCTest

final class MovieListViewModelTest: XCTestCase {
    var viewState: ViewData<[Movie]>!
    var movieListViewModel: MovieListViewModelProtocol!
    let mockMoviesAPIService = MockMoviesAPIService()
    let mockRepository = MockRepository<Movie>()

    override func setUpWithError() throws {
        movieListViewModel = MovieListViewModel(
            movieAPIService: mockMoviesAPIService,
            repository: mockRepository
        )
        viewState = nil
        movieListViewModel.updateViewData = { result in
            self.viewState = result
        }
    }

    override func tearDownWithError() throws {}

    func testStart() {
        movieListViewModel.start()
        if case .noData = viewState {
            XCTAssertTrue(true)
        } else {
            XCTAssertTrue(false)
        }
    }
}
