// MovieCellViewModelTest.swift
// Copyright © RoadMap. All rights reserved.

@testable import MoviesApp
import XCTest

final class MovieCellViewModelTest: XCTestCase {
    var viewState: ViewData<UIImage>!
    var movieCellViewModel: MovieCellViewModelProtocol!
    let mockMoviesAPIService = MockMoviesAPIService()

    override func setUpWithError() throws {
        movieCellViewModel = MovieCellViewModel()
        viewState = nil
        movieCellViewModel.updateViewData = { result in
            self.viewState = result
        }
    }

    func testShowImage() {
        movieCellViewModel.showPosterImage(path: "db")
        if case .loading = viewState {
            XCTAssertTrue(true)
        } else {
            XCTAssertTrue(false)
        }
    }
}
