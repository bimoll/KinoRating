// ApplicationCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

final class ApplicationCoordinator: BaseCoordinatorProtocol {
    // MARK: - Public Properties

    var childCoordinators: [BaseCoordinatorProtocol] = []

    // MARK: - Private Properties

    private var assembly: AssemblyProtocol
    private var navigationController: UINavigationController?

    // MARK: - Initialization

    required init(assembly: AssemblyProtocol, navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        self.assembly = assembly
    }

    // MARK: - Public Methods

    func start() {
        toMovieListFlow()
    }

    // MARK: - Private Methods

    private func toMovieListFlow() {
        let movieListCoordinator = MovieListCoordinator(
            assembly: assembly,
            navigationController: BaseNavigationController()
        )
        movieListCoordinator.onFinishFlow = { [weak self] in
            self?.removeDependency(movieListCoordinator)
            self?.start()
        }
        addDependency(movieListCoordinator)
        movieListCoordinator.start()
    }
}
