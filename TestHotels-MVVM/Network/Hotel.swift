struct Hotel: Codable {
    let id: Int
    let name: String
    let address: String
    let stars: Double
    let distance: Double

    var suitesAvailability: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance
        case suitesAvailability = "suites_availability"
    }
    
    init(
        id: Int,
        name: String,
        address: String,
        stars: Double,
        distance: Double,
        suitesAvailability: [String]
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.stars = stars
        self.distance = distance
        self.suitesAvailability = suitesAvailability
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
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
    }
}
