// MovieDetailViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MovieDetailViewController: UIViewController {
    // MARK: - Private Properties

    private let networkManager = NetworkService()
    private let movieDetailView = MovieDetailView()
    private var movieID: Int?

    // MARK: - UIViewController(MovieDetailViewController)

    override func loadView() {
        view = movieDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getMoviesInfo(id: movieID)
    }

    // MARK: - Public Methods

    func setMovieID(id: Int?) {
        movieID = id
    }

    // MARK: - Private Methods

    private func getMoviesInfo(id: Int?) {
        guard let id = id else { return }
        networkManager.getMoviesInfo(urlString: Constants.getMovieDetailURLString(id: id)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(json):
                guard let movieInfo = json else { return }
                self.success(movieInfo: movieInfo)
            case .failure:
                self.failure()
            }
        }
    }

    private func success(movieInfo: MovieInfo) {
        movieDetailView.setMovieInfo(movieInfo: movieInfo)
        navigationItem.title = movieInfo.title
    }

    private func failure() {
        showLoadingErrorAlert(title: "Нет подключения к интернету", message: "Попробовать еще?") {
            self.getMoviesInfo(id: self.movieID)
        }
    }

    private func showPosterImage(path: String?, completion: @escaping (UIImage?) -> ()) {
        let posterURLString = Constants.getPosterURLString(path: path ?? "")

        guard let posterURL = URL(string: posterURLString) else {
            completion(nil)
            return
        }

        networkManager.downloadImage(url: posterURL) { result in
            switch result {
            case let .success(data):
                guard let data = data, let image = UIImage(data: data) else { return }
                completion(image)
            case .failure:
                completion(nil)
            }
        }
    }
}
