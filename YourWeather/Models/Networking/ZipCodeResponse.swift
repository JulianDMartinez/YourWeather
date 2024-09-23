//
//  ZipCodeResponse.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import Foundation

struct ZipCodeResponse: Codable {
    let zip: String
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case zip
        case name
        case latitude = "lat"
        case longitude = "lon"
        case country
    }
}
