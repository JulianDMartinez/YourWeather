//
//  WeatherScreenViewModelTests.swift
//  YourWeatherTests
//
//  Created by Julian Martinez on 9/23/24.
//

import XCTest
import SwiftUI
import CoreLocation
@testable import YourWeather

@MainActor
final class WeatherScreenViewModelTests: XCTestCase {
    var viewModel: WeatherScreenViewModel!
    var weatherServiceMock: WeatherServiceMock!
    var locationServiceMock: LocationServiceMock!

    override func setUp() {
        super.setUp()
        weatherServiceMock = WeatherServiceMock()
        locationServiceMock = LocationServiceMock()
        viewModel = WeatherScreenViewModel(weatherService: weatherServiceMock, locationService: locationServiceMock)
    }

    override func tearDown() {
        viewModel = nil
        weatherServiceMock = nil
        locationServiceMock = nil
        super.tearDown()
    }

    func testFetchWeatherByCitySuccess() async {
        // Given
        let geocodingResponse = [
            GeocodingResponse(
                name: "London",
                localNames: nil,
                latitude: 51.5074,
                longitude: -0.1278,
                country: "GB",
                state: "England"
            )
        ]
        let weatherResponse = WeatherResponse(
            coordinates: Coordinates(longitude: -0.1278, latitude: 51.5074),
            weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
            base: nil,
            main: Main(
                temp: 15.0,
                feelsLike: 14.0,
                tempMin: nil,
                tempMax: nil,
                pressure: 1012,
                humidity: 72,
                seaLevel: nil,
                groundLevel: nil
            ),
            visibility: nil,
            wind: Wind(speed: 5.0, degrees: 200, gust: nil),
            rain: nil,
            clouds: nil,
            snow: nil,
            timeOfData: 1605182400,
            sys: Sys(type: nil, id: nil, country: "GB", sunrise: nil, sunset: nil),
            timezone: 0,
            name: "London",
            code: nil
        )
        weatherServiceMock.geocodingResult = .success(geocodingResponse)
        weatherServiceMock.weatherResult = .success(weatherResponse)

        // When
        viewModel.city = "London"
        await viewModel.fetchWeatherByCity()

        // Then
        XCTAssertEqual(viewModel.weatherResponse?.name, "London")
        XCTAssertEqual(viewModel.weatherResponse?.main.temp, 15.0)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFetchWeatherByCityFailure() async {
        // Given
        weatherServiceMock.geocodingResult = .failure(WeatherServiceError.cityNotFound)

        // When
        viewModel.city = "InvalidCity"
        await viewModel.fetchWeatherByCity()

        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, WeatherServiceError.cityNotFound.localizedDescription)
    }

    func testFetchWeatherByLocationSuccess() {
        // Given
        locationServiceMock.isLocationFeatureEnabled = true
        locationServiceMock.coordinateResult = .success(CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278))
        let weatherResponse = WeatherResponse(
            coordinates: Coordinates(longitude: -0.1278, latitude: 51.5074),
            weather: [],
            base: nil,
            main: Main(
                temp: 15.0,
                feelsLike: 14.0,
                tempMin: nil,
                tempMax: nil,
                pressure: 1012,
                humidity: 72,
                seaLevel: nil,
                groundLevel: nil
            ),
            visibility: nil,
            wind: Wind(speed: 5.0, degrees: 200, gust: nil),
            rain: nil,
            clouds: nil,
            snow: nil,
            timeOfData: 1605182400,
            sys: Sys(type: nil, id: nil, country: "GB", sunrise: nil, sunset: nil),
            timezone: 0,
            name: "London",
            code: nil
        )
        weatherServiceMock.weatherResult = .success(weatherResponse)

        let expectation = XCTestExpectation(description: "Weather fetched by location")

        // When
        viewModel.fetchWeatherByLocationForInteraction()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Then
            XCTAssertEqual(self.viewModel.weatherResponse?.name, "London")
            XCTAssertEqual(self.viewModel.weatherResponse?.main.temp, 15.0)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWeatherByLocationNoAuthorization() {
        // Given
        locationServiceMock.isLocationFeatureEnabled = false

        // When
        viewModel.fetchWeatherByLocationForInteraction()

        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(
            viewModel.errorMessage,
            "Location services isn't currently enabled. Please enable location services under Settings -> YourWeather to use the current location."
        )
    }
}
