// RealmRepository.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

final class RealmReporitory<DomainModel: Object>: Repository<DomainModel> {
    private lazy var realm: Realm? = {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try? Realm(configuration: realmConfig)
        return realm
    }()

    override func get(predicate: NSPredicate, completion: @escaping ResultHandler<[DomainModel]>) {
        guard let objects = realm?.objects(DomainModel.self).filter(predicate) else {
            completion(.failure(CustomErrors.fetchedDataIsNil))
            return
        }
        completion(.success(Array(objects)))
    }

    override func save(_ objects: [DomainModel]) {
        realm?.beginWrite()
        realm?.add(objects, update: .all)
        try? realm?.commitWrite()
    }
}
