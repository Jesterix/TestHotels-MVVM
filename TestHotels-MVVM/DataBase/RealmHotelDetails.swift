import Foundation
import RealmSwift

class RealmHotelDetails: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var stars: Double = 0.0
    @objc dynamic var distance: Double = 0.0
    let suitesAvailability = List<String>()
    @objc dynamic var imageName: String? = nil
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    
    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(from hotel: HotelDetails) {
        self.init()
        id = hotel.id
        name = hotel.name
        address = hotel.address
        stars = hotel.stars
        distance = hotel.distance
        suitesAvailability.append(objectsIn: hotel.suitesAvailability)
        imageName = hotel.imageName
        lat = hotel.lat
        lon = hotel.lon
    }

    func converted() -> HotelDetails {
        return HotelDetails(
            id: id,
            name: name,
            address: address,
            stars: stars,
            distance: distance,
            suitesAvailability: suitesAvailability.map { $0 },
            imageName: imageName,
            lat: lat,
            lon: lon
        )
    }
}
