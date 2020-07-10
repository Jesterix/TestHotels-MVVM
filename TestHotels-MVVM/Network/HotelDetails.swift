struct HotelDetails: Codable {
    let imageName: String?
    let lat: Double
    let lon: Double

    enum CodingKeys: String, CodingKey {
        case lat, lon
        case imageName = "image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)

        let imageNameFull = try container.decode(String?.self, forKey: .imageName)

        guard let name = imageNameFull, name.count > 0 else {
            imageName = nil
            return
        }
        imageName = String(name.split(separator: ".")[0])
    }
}
