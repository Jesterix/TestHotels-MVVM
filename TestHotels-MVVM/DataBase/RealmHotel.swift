import Foundation
import RealmSwift

class RealmHotel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var stars: Double = 0.0
    @objc dynamic var distance: Double = 0.0
    let suitesAvailability = List<String>()
    
    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(from hotel: Hotel) {
        self.init()
        id = hotel.id
        name = hotel.name
        address = hotel.address
        stars = hotel.stars
        distance = hotel.distance
        suitesAvailability.append(objectsIn: hotel.suitesAvailability)
    }

    func converted() -> Hotel {
        return Hotel(
            id: id,
            name: name,
            address: address,
            stars: stars,
            distance: distance,
            suitesAvailability: suitesAvailability.map { $0 }
        )
    }
}
