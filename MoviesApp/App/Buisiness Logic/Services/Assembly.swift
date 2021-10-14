// Assembly.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol AssemblyProtocol {
    func createDetailMoviesModule(_ movieID: Int?) -> UIViewController
    func createMovieListModule() -> MoviesListViewControllerProtocol
}

final class Assembly: AssemblyProtocol {
    func createMovieListModule() -> MoviesListViewControllerProtocol {
        let movieAPIService = MovieAPIService()
        let viewModel = MovieListViewModel(movieAPIService: movieAPIService)
        return MoviesListViewController(viewModel: viewModel)
    }

    func createDetailMoviesModule(_ movieID: Int?) -> UIViewController {
        let moviesAPIService = MovieAPIService()
        let viewModel = MovieDetailViewModel(movieID: movieID, moviesAPIService: moviesAPIService)
        return MovieDetailViewController(viewModel)
    }
}
