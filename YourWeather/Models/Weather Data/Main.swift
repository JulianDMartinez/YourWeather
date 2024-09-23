//
//  Main.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import Foundation

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let groundLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
    }
}
