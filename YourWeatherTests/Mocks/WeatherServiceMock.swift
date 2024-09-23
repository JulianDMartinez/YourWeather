//
//  WeatherServiceMock.swift
//  YourWeatherTests
//
//  Created by Julian Martinez on 9/23/24.
//

import Foundation
@testable import YourWeather

class WeatherServiceMock: WeatherServiceProtocol {
    var weatherResult: Result<WeatherResponse, Error>?
    var geocodingResult: Result<[GeocodingResponse], Error>?
    var iconDataResult: Result<Data, Error>?

    func fetchWeather(forLatitude latitude: Double, longitude: Double) async throws -> WeatherResponse {
        if let result = weatherResult {
            switch result {
            case .success(let weatherResponse):
                return weatherResponse
            case .failure(let error):
                throw error
            }
        }
        throw WeatherServiceError.invalidURL
    }

    func fetchWeatherIcon(iconCode: String) async throws -> Data {
        if let result = iconDataResult {
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                throw error
            }
        }
        throw WeatherServiceError.iconNotFound
    }

    func geocode(cityName: String) async throws -> [GeocodingResponse] {
        if let result = geocodingResult {
            switch result {
            case .success(let geocodingResponse):
                return geocodingResponse
            case .failure(let error):
                throw error
            }
        }
        throw WeatherServiceError.cityNotFound
    }
}
