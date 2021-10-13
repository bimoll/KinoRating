// CoordinatorTests.swift
// Copyright © RoadMap. All rights reserved.

@testable import MoviesApp
import XCTest

final class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

final class CoordinatorTests: XCTestCase {
    var coordinator: ApplicationCoordinator!
    var mockNavigationController: MockNavigationController!

    override func setUpWithError() throws {
        mockNavigationController = MockNavigationController()
        coordinator = ApplicationCoordinator(assembly: Assembly(), navigationController: mockNavigationController)
    }

    override func tearDownWithError() throws {
        mockNavigationController = nil
        coordinator = nil
    }

    func testValidPresentation() {
        coordinator.start()
        XCTAssertTrue(mockNavigationController.presentedVC is UIViewController)
    }
}
