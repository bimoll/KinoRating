// MockRepository.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
@testable import MoviesApp

final class MockRepository<Model>: Repository<Model> {
    override func save(_ objects: [Model]) {}
    override func get(predicate: NSPredicate, completion: @escaping ResultHandler<[Model]>) {
        completion(.success([]))
    }
}
