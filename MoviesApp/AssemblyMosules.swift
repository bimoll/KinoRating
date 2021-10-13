// AssemblyMosules.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol AssemblyProtocol {
    static func createDetailMoviesModule(_ movieID: Int?) -> UIViewController
}

final class Assembly: AssemblyProtocol {
    static func createDetailMoviesModule(_ movieID: Int?) -> UIViewController {
        let moviesAPIService = MovieAPIService()
        let viewModel = MovieDetailViewModel(movieID: movieID, moviesAPIService: moviesAPIService)
        return MovieDetailViewController(viewModel)
    }
}
