// RealmRepositoryTest.swift
// Copyright © RoadMap. All rights reserved.

@testable import MoviesApp
import XCTest

final class RealmRepositoryTest: XCTestCase {
    var repository: RealmReporitory<Movie>!
    let movie = Movie()

    override func setUpWithError() throws {
        movie.title = "test"
        repository = RealmReporitory<Movie>()
    }

    override func tearDownWithError() throws {
        repository = nil
    }

    func testRepository() {
        repository.save([movie])
        repository.get(predicate: NSPredicate(format: "title == %@", movie.title)) { result in
            if case let .success(movies) = result {
                XCTAssertEqual(movies[0].title, self.movie.title)
            }
        }
    }
}
