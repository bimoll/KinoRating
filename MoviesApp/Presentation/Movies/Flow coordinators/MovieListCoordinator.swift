// MovieListCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MovieListCoordinator: BaseCoordinatorProtocol {
    var childCoordinators: [BaseCoordinatorProtocol] = []
    var onFinishFlow: VoidHandler?

    private var assembly: AssemblyProtocol
    private var navigationController: UINavigationController

    required init(assembly: AssemblyProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.assembly = assembly
    }

    func start() {
        showMainListModel()
    }

    private func showMainListModel() {
        let movieListVC = assembly.createMovieListModule()
        movieListVC.toMovieDetail = { [weak self] id in
            self?.showDetailMovie(id)
        }

        navigationController.pushViewController(movieListVC, animated: true)
        setAsRoot(navigationController)
    }

    private func showDetailMovie(_ id: Int?) {
        let detailVC = assembly.createDetailMoviesModule(id)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
