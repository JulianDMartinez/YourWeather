//
//  Clouds.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import Foundation

struct Clouds: Codable {
    let coverage: Int
    
    enum CodingKeys: String, CodingKey {
        case coverage = "all"
    }
}
