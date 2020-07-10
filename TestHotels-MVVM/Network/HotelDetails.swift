struct HotelDetails: Codable {
    let imageName: String?
    let lat: Double
    let lon: Double
    let id: Int
    let name: String
    let address: String
    let stars: Double
    let distance: Double
    
    var suitesAvailability: [String]
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, id, name, address, stars, distance
        case imageName = "image"
        case suitesAvailability = "suites_availability"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        stars = try container.decode(Double.self, forKey: .stars)
        distance = try container.decode(Double.self, forKey: .distance)
        
        let suitesAvailabilityString = try container.decode(
            String.self,
            forKey: .suitesAvailability)
        
        suitesAvailability = suitesAvailabilityString.split(
            separator: ":",
            omittingEmptySubsequences: true).map { String($0) }
        
        let imageNameFull = try container.decode(String?.self, forKey: .imageName)

        guard let name = imageNameFull, name.count > 0 else {
            imageName = nil
            return
        }
        imageName = String(name.split(separator: ".")[0])
    }
}
