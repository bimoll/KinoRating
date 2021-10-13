// MovieDetailViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MovieDetailViewModelProtocol {
    var updateViewData: ViewDataHandler<MovieInfo>? { get set }
    func getMovieInfo()
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    // MARK: - Public Properties

    var updateViewData: ViewDataHandler<MovieInfo>?

    // MARK: - Private Properties

    private let movieAPIService: MovieAPIServiceProtocol
    private var movieID: Int?

    // MARK: - Initialization

    init(movieID: Int?, moviesAPIService: MovieAPIServiceProtocol) {
        movieAPIService = moviesAPIService
        self.movieID = movieID
    }

    // MARK: - Public Methods

    func getMovieInfo() {
        guard let id = movieID else { return }
        movieAPIService.getDecodable(
            urlString: Constants.getMovieDetailURLString(id: id),
            to: MovieInfo.self
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(json):
                guard let movieInfo = json else {
                    self.updateViewData?(.noData)
                    return
                }
                self.updateViewData?(.data(movieInfo))
            case let .failure(error):
                self.updateViewData?(.error(error))
            }
        }
    }
}
