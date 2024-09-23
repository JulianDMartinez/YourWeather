//
//  YourWeatherApp.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import CoreLocation
import SwiftUI

@main
struct YourWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherScreen(viewModel: getConfiguredViewModel())
        }
    }

    func getConfiguredViewModel() -> WeatherScreenViewModel {
        let isUITesting = CommandLine.arguments.contains("--uitesting")
        let viewModel: WeatherScreenViewModel

        if isUITesting {
            viewModel = getUITestingViewModel()
        } else {
            viewModel = WeatherScreenViewModel(
                weatherService: WeatherService(apiClient: APIClient()),
                locationService: LocationService()
            )
        }

        return viewModel
    }
    
    func getUITestingViewModel() -> WeatherScreenViewModel {
        let weatherServiceMock = WeatherServiceMock()
        // Set up mock data for geocoding
        let mockGeocodingResponse = [
            GeocodingResponse(
                name: "Test City",
                localNames: nil,
                latitude: 51.5074,
                longitude: -0.1278,
                country: "GB",
                state: "Test State"
            ),
        ]
        weatherServiceMock.geocodingResult = .success(mockGeocodingResponse)

        // Set up mock data for weather
        let mockWeatherResponse = WeatherResponse(
            coordinates: Coordinates(longitude: -0.1278, latitude: 51.5074),
            weather: [Weather(
                id: 800,
                main: "Clear",
                description: "clear sky",
                icon: "01d"
            )],
            base: "stations",
            main: Main(
                temp: 20.0,
                feelsLike: 19.0,
                tempMin: 18.0,
                tempMax: 22.0,
                pressure: 1012,
                humidity: 60,
                seaLevel: nil,
                groundLevel: nil
            ),
            visibility: 10000,
            wind: Wind(speed: 3.5, degrees: 200, gust: nil),
            rain: nil,
            clouds: Clouds(coverage: 0),
            snow: nil,
            timeOfData: Int(Date().timeIntervalSince1970),
            sys: Sys(type: nil, id: nil, country: "GB", sunrise: nil, sunset: nil),
            timezone: 0,
            name: "Test City",
            code: 200
        )
        weatherServiceMock.weatherResult = .success(mockWeatherResponse)

        let locationServiceMock = LocationServiceMock()
        locationServiceMock.isLocationFeatureEnabled = true
        locationServiceMock.coordinateResult = .success(CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
        return WeatherScreenViewModel(
            weatherService: weatherServiceMock,
            locationService: locationServiceMock
        )
    }
}
