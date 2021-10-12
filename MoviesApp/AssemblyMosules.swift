// AssemblyMosules.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol AssemblyModulesProtocol {
    static func createDetailMoviesModule(_ movieID: Int?) -> UIViewController
}

final class AssemblyModules: AssemblyModulesProtocol {
    static func createDetailMoviesModule(_ movieID: Int?) -> UIViewController {
        let moviesAPIService = MovieAPIService()
        let viewModel = MovieDetailViewModel(movieID: movieID, moviesAPIService: moviesAPIService)
        return MovieDetailViewController(viewModel)
    }
}
