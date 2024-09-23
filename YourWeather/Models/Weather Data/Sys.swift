//
//  Sys.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import Foundation

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int?
    let sunset: Int?
}
