// Repository.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol RepositoryProtocol: AnyObject {
    associatedtype DomainModel

    func save(_ objects: [DomainModel])
    func get(predicate: NSPredicate, completion: @escaping ResultHandler<[DomainModel]>)
    func delete()
}

/// Базовый класс репозитория
class Repository<DomainModel>: RepositoryProtocol {
    typealias DomainModel = DomainModel

    func save(_ objects: [DomainModel]) {
        fatalError("override required")
    }

    func get(predicate: NSPredicate, completion: @escaping ResultHandler<[DomainModel]>) {
        fatalError("override required")
    }

    func delete() {
        fatalError("override required")
    }
}
