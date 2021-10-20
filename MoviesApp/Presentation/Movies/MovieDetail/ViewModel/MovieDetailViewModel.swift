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

    private let repository: Repository<MovieInfo>
    private let movieAPIService: MovieAPIServiceProtocol
    private var movieID: Int?

    // MARK: - Initialization

    init(movieID: Int?, moviesAPIService: MovieAPIServiceProtocol, repository: Repository<MovieInfo>) {
        self.repository = repository
        movieAPIService = moviesAPIService
        self.movieID = movieID
    }

    // MARK: - Public Methods

    func getMovieInfo() {
        guard let id = movieID else {
            updateViewData?(.noData)
            return
        }

        repository.get(predicate: NSPredicate(format: "id == \(id)")) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(objects):
                guard !objects.isEmpty,
                      let movieInfo = objects.first
                else {
                    self.getMoviesFromNetwork(id: id)
                    return
                }
                DispatchQueue.main.async {
                    self.updateViewData?(.data(movieInfo))
                }
            case let .failure(error):
                self.updateViewData?(.error(error))
            }
        }
    }

    // MARK: - Private Properties

    private func getMoviesFromNetwork(id: Int) {
        movieAPIService.getDecodable(
            urlString: URLConstants.getMovieDetailURLString(id: id),
            to: MovieInfo.self
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(movieInfo):
                guard let movieInfo = movieInfo else {
                    self.updateViewData?(.noData)
                    return
                }
                self.repository.save([movieInfo])
                self.updateViewData?(.data(movieInfo))
            case let .failure(error):
                self.updateViewData?(.error(error))
            }
        }
    }
}
