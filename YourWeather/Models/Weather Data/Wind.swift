//
//  Wind.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import Foundation

struct Wind: Codable {
    let speed: Double
    let degrees: Int
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
        case gust
    }
}
