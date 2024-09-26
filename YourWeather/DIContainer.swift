//
//  DIContainer.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/23/24.
//

import Foundation

class DIContainer {
    let apiClient: APIClientProtocol
    let weatherService: WeatherServiceProtocol
    let locationService: LocationServiceProtocol

    init(
        apiClient: APIClientProtocol,
        weatherService: WeatherServiceProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.apiClient = apiClient
        self.weatherService = weatherService
        self.locationService = locationService
    }

    static func makeDefault() -> DIContainer {
        let apiClient = APIClient()
        let weatherService = WeatherService(apiClient: apiClient)
        let locationService = LocationService()
        return DIContainer(
            apiClient: apiClient,
            weatherService: weatherService,
            locationService: locationService
        )
    }

    static func makeMock() -> DIContainer {
        let apiClient = APIClientMock()
        let weatherService = WeatherServiceMock()
        let locationService = LocationServiceMock()
        return DIContainer(
            apiClient: apiClient,
            weatherService: weatherService,
            locationService: locationService
        )
    }
}
