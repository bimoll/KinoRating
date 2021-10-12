// MovieDetailViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MovieDetailViewController: UIViewController {
    // MARK: - Private Properties

    private let movieDetailView = MovieDetailView()
    private var viewModel: MovieDetailViewModelProtocol
    private var viewData: ViewData<MovieInfo>? {
        didSet { fetchUpdates() }
    }

    // MARK: - Initialization

    init(_ viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController(MovieDetailViewController)

    override func loadView() {
        view = movieDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupModel()
    }

    // MARK: - Private Methods

    private func setupModel() {
        viewModel.updateViewData = { [weak self] viewData in
            self?.viewData = viewData
        }
        viewData = .loading
        viewModel.getMovieInfo()
    }

    private func fetchUpdates() {
        switch viewData {
        case .loading:
            movieDetailView.startLoading()
        case let .data(movieInfo):
            movieDetailView.showMoviesInfo(movieInfo)
            navigationItem.title = movieInfo.title
        case .error, .noData, .none:
            failure()
        }
    }

    private func failure() {
        showLoadingErrorAlert(title: "Нет подключения к интернету", message: "Попробовать еще?") { [weak self] in
            self?.viewModel.getMovieInfo()
        }
    }
}
