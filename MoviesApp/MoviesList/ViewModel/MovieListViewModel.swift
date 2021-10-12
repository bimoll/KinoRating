// MovieListViewModel.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol MovieListViewModelProtocol {
    var movies: [Movie] { get set }
    var updateViewData: ViewDataHandler<[Movie]>? { get set }
    var startLoadingAnimations: VoidHandler? { get set }
    var reloadCollection: VoidHandler? { get set }
    func getMoviesPage(_ urlString: String)
    func searchMovies(_ textField: UITextField, isPaginate: Bool)
    func setCurrentCategory(_ category: MoviesCategories)
    func getCurrentCategory() -> MoviesCategories
}

final class MovieListViewModel: MovieListViewModelProtocol {
    // MARK: - Public Properties

    var startLoadingAnimations: VoidHandler?
    var updateViewData: ViewDataHandler<[Movie]>?
    var reloadCollection: VoidHandler?
    var movies: [Movie] = [] {
        didSet {
            reloadCollection?()
        }
    }

    // MARK: - Private Properties

    private var networkService = NetworkService()
    private var nextPageNumber = 1 {
        didSet {
            if nextPageNumber == 1 { movies.removeAll() }
        }
    }

    private lazy var moviesCategories: MoviesCategories = .popular {
        didSet {
            nextPageNumber = 1
            getMoviesPage(moviesCategories.getUrlString(page: nextPageNumber))
        }
    }

    // MARK: - Public Methods

    func getMoviesPage(_ urlString: String) {
        startLoadingAnimations?()
        networkService.getMoviesPage(urlString: urlString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(page):
                guard let movies = page?.results else {
                    self.updateViewData?(.noData)
                    return
                }
                self.updateViewData?(.data(movies))
                self.setNextPageNumber(page)
            case let .failure(error):
                self.updateViewData?(.error(error))
            }
        }
    }

    func searchMovies(_ textField: UITextField, isPaginate: Bool) {
        if !isPaginate { nextPageNumber = 1 }
        if textField.hasText, let text = textField.text?.replacingOccurrences(of: " ", with: "%20") {
            getMoviesPage(Constants.getSearchMoviesURLString(page: nextPageNumber, searchedText: text))
        } else {
            if !isPaginate {
                setCategories()
                return
            }

            let urlString = moviesCategories.getUrlString(page: nextPageNumber)
            getMoviesPage(urlString)
        }
    }

    func setCurrentCategory(_ category: MoviesCategories) {
        moviesCategories = category
    }

    func getCurrentCategory() -> MoviesCategories {
        moviesCategories
    }

    // MARK: - Private Methods

    private func setCategories() {
        let url = moviesCategories.getUrlString(page: 1)
        getMoviesPage(url)
    }

    private func setNextPageNumber(_ page: MoviesListPage?) {
        guard
            let currentPageNumber = page?.page,
            let totalPages = page?.totalPages,
            currentPageNumber < totalPages
        else {
            nextPageNumber = -1
            return
        }
        nextPageNumber = currentPageNumber + 1
    }
}
