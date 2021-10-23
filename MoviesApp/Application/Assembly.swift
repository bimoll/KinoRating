// Assembly.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol AssemblyProtocol {
    func createDetailMoviesModule(_ movieID: Int?) -> UIViewController
    func createMovieListModule() -> MoviesListViewControllerProtocol
}

final class Assembly: AssemblyProtocol {
    private let moviesAPIService = MovieAPIService()

    func createMovieListModule() -> MoviesListViewControllerProtocol {
        let repository = RealmReporitory<Movie>()
        let viewModel = MovieListViewModel(movieAPIService: moviesAPIService, repository: repository)
        return MoviesListViewController(viewModel: viewModel)
    }

    func createDetailMoviesModule(_ movieID: Int?) -> UIViewController {
        let repository = RealmReporitory<MovieInfo>()
        let viewModel = MovieDetailViewModel(
            movieID: movieID,
            moviesAPIService: moviesAPIService,
            repository: repository
        )
        return MovieDetailViewController(viewModel)
    }
}
