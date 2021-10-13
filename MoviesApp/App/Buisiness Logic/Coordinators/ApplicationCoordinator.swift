// ApplicationCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

final class ApplicationCoordinator: BaseCoordinatorProtocol {
    var childCoordinators: [BaseCoordinatorProtocol] = []
    private var assembly: AssemblyProtocol

    required init(assembly: AssemblyProtocol) {
        self.assembly = assembly
    }

    func start() {
        toMovieListFlow()
    }

    private func toMovieListFlow() {
        let movieListCoordinator = MovieListCoordinator(assembly: assembly)
        movieListCoordinator.onFinishFlow = { [weak self] in
            self?.removeDependency(movieListCoordinator)
            self?.start()
        }
        addDependency(movieListCoordinator)
        movieListCoordinator.start()
    }
}
