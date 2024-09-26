//
//  WeatherServiceTests.swift
//  YourWeatherTests
//
//  Created by Julian Martinez on 9/23/24.
//

import XCTest
@testable import YourWeather

final class WeatherServiceTests: XCTestCase {
    var weatherService: WeatherService!
    var apiClientMock: APIClientMock!

    override func setUp() {
        super.setUp()
        apiClientMock = APIClientMock()
        weatherService = WeatherService(apiClient: apiClientMock)
    }

    override func tearDown() {
        weatherService = nil
        apiClientMock = nil
        super.tearDown()
    }

    func testFetchWeatherSuccess() async throws {
        // Given
        let expectedWeatherResponse = WeatherResponse(
            coordinates: Coordinates(longitude: -0.1278, latitude: 51.5074),
            weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
            base: "stations",
            main: Main(
                temp: 15.0,
                feelsLike: 14.0,
                tempMin: 14.0,
                tempMax: 16.0,
                pressure: 1012,
                humidity: 72,
                seaLevel: nil,
                groundLevel: nil
            ),
            visibility: 10000,
            wind: Wind(speed: 5.0, degrees: 200, gust: nil),
            rain: nil,
            clouds: Clouds(coverage: 0),
            snow: nil,
            timeOfData: 1605182400,
            sys: Sys(type: nil, id: nil, country: "GB", sunrise: nil, sunset: nil),
            timezone: 0,
            name: "London",
            code: 200
        )

        let data = try JSONEncoder().encode(expectedWeatherResponse)
        apiClientMock.result = .success(data)

        // When
        let weatherResponse = try await weatherService.fetchWeather(forLatitude: 51.5074, longitude: -0.1278)

        // Then
        XCTAssertEqual(weatherResponse.name, "London")
        XCTAssertEqual(weatherResponse.main.temp, 15.0)
    }

    func testFetchWeatherIconSuccess() async throws {
            // Given
            let expectedData = Data([0x89, 0x50, 0x4E, 0x47]) // PNG file header bytes
            apiClientMock.result = .success(expectedData)

            // When
            let data = try await weatherService.fetchWeatherIcon(iconCode: "01d")

            // Then
            XCTAssertEqual(data, expectedData)
        XCTAssertEqual(
            apiClientMock.urlRequest?.url?.absoluteString,
            "\(GlobalSettings.openWeatherIconBasePath)/img/wn/01d@2x.png"
        )
        }

        func testFetchWeatherIconFailure() async {
            // Given
            apiClientMock.result = .failure(APIError.invalidResponse)

            // When & Then
            do {
                _ = try await weatherService.fetchWeatherIcon(iconCode: "01d")
                XCTFail("Expected to throw an error but did not")
            } catch {
                XCTAssertTrue(error is APIError)
            }
        }

    func testGeocodeSuccess() async throws {
        // Given
        let expectedGeocodingResponse = [
            GeocodingResponse(
                name: "London",
                localNames: nil,
                latitude: 51.5074,
                longitude: -0.1278,
                country: "GB",
                state: "England"
            )
        ]

        let data = try JSONEncoder().encode(expectedGeocodingResponse)
        apiClientMock.result = .success(data)

        // When
        let geocodingResponse = try await weatherService.geocode(cityName: "London")

        // Then
        XCTAssertEqual(geocodingResponse.first?.name, "London")
        XCTAssertEqual(geocodingResponse.first?.country, "GB")
    }

    func testGeocodeFailure() async {
        // Given
        apiClientMock.result = .failure(APIError.invalidResponse)

        // When & Then
        do {
            _ = try await weatherService.geocode(cityName: "InvalidCity")
            XCTFail("Expected to throw an error but did not")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
}
