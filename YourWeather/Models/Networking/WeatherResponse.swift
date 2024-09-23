//
//  WeatherResponse.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import Foundation

struct WeatherResponse: Codable {
    let coordinates: Coordinates
    let weather: [Weather]
    let base: String?
    let main: Main
    let visibility: Int?
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds?
    let snow: Snow?
    let timeOfData: Int
    let sys: Sys
    let timezone: Int
    let name: String
    let code: Int?
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case rain
        case clouds
        case snow
        case timeOfData = "dt"
        case sys
        case timezone
        case name
        case code = "cod"
    }
}
