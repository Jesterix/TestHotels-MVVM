//
//  Repository.swift
//  TestHotels-MVVM
//
//  Created by Georgy Khaydenko on 29.08.2020.
//  Copyright © 2020 Georgy Khaydenko. All rights reserved.
//

import RealmSwift

public final class Repository {
    
    // MARK: - Initialization
    public var errorHandler: ((RepositoryError) -> ())?
    fileprivate let realm: Realm
    
    public init() {
        realm = try! Realm()
    }
}

// MARK: - Save
extension Repository {
    
    public func save<T: Object>(_ entity: T) {
        save {
            realm.add(entity, update: .all)
        }
    }
    
    public func save<T: Object>(_ entities: [T]) {
        save {
            realm.add(entities, update: .all)
        }
    }
    
    fileprivate func save(_ closure: () -> ()) {
        do {
            try realm.write {
                closure()
            }
        } catch let error {
            print("Realm write transaction error \(error)")
            fireError(error: error)
        }
    }
}

// MARK: - Find
extension Repository {
    
    public func getEntity<T: Object>(byId id: Int) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    public func getEntities<T: Object>(byIds ids: [Int]) -> [T] {
        return ids.compactMap { getEntity(byId: $0) }
    }
    
    public func getEntity<T: Object>(byStringId id: String) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    public func getEntities<T: Object>(byStringIds ids: [String]) -> [T] {
        return ids.compactMap { getEntity(byStringId: $0) }
    }
}

// MARK: - Error handling
extension Repository {
    
    fileprivate func fireError(error: Error) {
        fireError(repositoryError: RepositoryError.error(fromRealmError: error))
    }
    
    fileprivate func fireError(repositoryError: RepositoryError) {
        errorHandler?(repositoryError)
    }
}
