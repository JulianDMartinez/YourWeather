//
//  Rain.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import Foundation

struct Rain: Codable {
    let oneHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}
