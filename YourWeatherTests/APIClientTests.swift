//
//  APIClientTests.swift
//  YourWeatherTests
//
//  Created by Julian Martinez on 9/23/24.
//

import XCTest
@testable import YourWeather

final class APIClientTests: XCTestCase {
    var apiClient: APIClient!
    var urlSessionMock: URLSessionProtocolMock!

    override func setUp() {
        super.setUp()
        urlSessionMock = URLSessionProtocolMock()
        apiClient = APIClient()
    }

    override func tearDown() {
        apiClient = nil
        urlSessionMock = nil
        super.tearDown()
    }

    func testPerformRequestSuccess() async throws {
        // Given
        let expectedResponse = WeatherResponse(
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
        let data = try JSONEncoder().encode(expectedResponse)
        urlSessionMock.data = data
        urlSessionMock.response = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        apiClient.urlSession = urlSessionMock

        // When
        let urlRequest = URLRequest(url: URL(string: "https://api.openweathermap.org")!)
        let response: WeatherResponse = try await apiClient.performRequest(with: urlRequest)

        // Then
        XCTAssertEqual(response.name, "London")
        XCTAssertEqual(response.main.temp, 15.0)
    }

    func testPerformDataRequestSuccess() async throws {
        // Given
        let expectedData = Data([0x89, 0x50, 0x4E, 0x47]) // PNG file header bytes
        urlSessionMock.data = expectedData
        urlSessionMock.response = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org/img/wn/01d@2x.png")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        apiClient.urlSession = urlSessionMock

        // When
        let urlRequest = URLRequest(url: URL(string: "https://api.openweathermap.org/img/wn/01d@2x.png")!)
        let data = try await apiClient.performDataRequest(with: urlRequest)

        // Then
        XCTAssertEqual(data, expectedData)
    }

    func testPerformDataRequestFailure() async {
        // Given
        urlSessionMock.error = APIError.invalidResponse
        apiClient.urlSession = urlSessionMock

        // When & Then
        do {
            let urlRequest = URLRequest(url: URL(string: "https://api.openweathermap.org/img/wn/01d@2x.png")!)
            _ = try await apiClient.performDataRequest(with: urlRequest)
            XCTFail("Expected to throw an error but did not")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
}

// URLSessionProtocol and URLSessionProtocolMock
class URLSessionProtocolMock: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data, let response = response else {
            throw APIError.invalidResponse
        }
        return (data, response)
    }
}


