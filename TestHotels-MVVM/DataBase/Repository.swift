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
    
    private func save<T: Object>(_ entity: T) {
        save {
            realm.add(entity, update: .all)
        }
    }
    
    private func save<T: Object>(_ entities: [T]) {
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
    
    private func getEntity<T: Object>(byId id: Int) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    private func getEntities<T: Object>(byIds ids: [Int]) -> [T] {
        return ids.compactMap { getEntity(byId: $0) }
    }
    
    private func getEntity<T: Object>(byStringId id: String) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    private func getEntities<T: Object>(byStringIds ids: [String]) -> [T] {
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

//MARK: - DataManager objects handling
extension Repository: DataManager {
    func getHotels() -> [Hotel] {
        let objects = self.realm.objects(RealmHotel.self)
        return objects.map { $0.converted()}
    }
    
    func save(details: HotelDetails) {
        save(RealmHotelDetails(from: details))
    }
    
    func save(hotel: Hotel) {
        save(RealmHotel(from: hotel))
    }
    
    func getDetails(byId: Int) -> HotelDetails? {
        let details: RealmHotelDetails? = getEntity(byId: byId)
        return details?.converted()
    }
}
