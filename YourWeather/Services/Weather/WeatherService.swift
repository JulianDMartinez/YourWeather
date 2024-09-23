//
//  WeatherService.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/23/24.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(forLatitude latitude: Double, longitude: Double) async throws -> WeatherResponse
    func fetchWeatherIcon(iconCode: String) async throws -> Data
    func geocode(cityName: String) async throws -> [GeocodingResponse]
}

class WeatherService: WeatherServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchWeather(forLatitude latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let urlString = "\(GlobalSettings.openWeatherBasePath)/data/2.5/weather"
        guard var urlComponents = URLComponents(string: urlString) else {
            throw WeatherServiceError.invalidURL
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "units", value: "imperial"),
            URLQueryItem(name: "appid", value: GlobalSettings.openWeatherAPIKey)
        ]

        guard let url = urlComponents.url else {
            throw WeatherServiceError.invalidURL
        }

        let urlRequest = URLRequest(url: url)
        return try await apiClient.performRequest(with: urlRequest)
    }
    
    func fetchWeatherIcon(iconCode: String) async throws -> Data {
        let urlString = "\(GlobalSettings.openWeatherIconBasePath)/img/wn/\(iconCode)@2x.png"
        
        guard let url = URL(string: urlString) else {
            throw WeatherServiceError.iconNotFound
        }

        let urlRequest = URLRequest(url: url)
        return try await apiClient.performDataRequest(with: urlRequest)
    }
       

    func geocode(cityName: String) async throws -> [GeocodingResponse] {
        let urlString = "\(GlobalSettings.openWeatherBasePath)/geo/1.0/direct"
        guard var urlComponents = URLComponents(string: urlString) else {
            throw WeatherServiceError.invalidURL
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "limit", value: "1"),
            URLQueryItem(name: "appid", value: GlobalSettings.openWeatherAPIKey)
        ]

        guard let url = urlComponents.url else {
            throw WeatherServiceError.invalidURL
        }

        let urlRequest = URLRequest(url: url)
        return try await apiClient.performRequest(with: urlRequest)
    }
}

enum WeatherServiceError: Error {
    case invalidURL
    case cityNotFound
    case iconNotFound
}
