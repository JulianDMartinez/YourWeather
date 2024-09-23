//
//  GeocodingResponse.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import Foundation

struct GeocodingResponse: Codable {
    let name: String
    let localNames: [String: String]?
    let latitude: Double
    let longitude: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case latitude = "lat"
        case longitude = "lon"
        case country
        case state
    }
}
