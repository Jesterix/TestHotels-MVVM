//
//  Hotel.swift
//  TestHotels
//
//  Created by Георгий Хайденко on 25.06.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

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
