//
//  DIContainer.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/23/24.
//

import Foundation

@MainActor
class DIContainer {
    let apiClient: APIClientProtocol
    let weatherService: WeatherServiceProtocol
    let locationService: LocationServiceProtocol

    let weatherScreenVM: WeatherScreenViewModel

    init() {
        apiClient = APIClient()
        weatherService = WeatherService(apiClient: apiClient)
        locationService = LocationService()

        weatherScreenVM = WeatherScreenViewModel(
            weatherService: weatherService,
            locationService: locationService
        )
    }
}
