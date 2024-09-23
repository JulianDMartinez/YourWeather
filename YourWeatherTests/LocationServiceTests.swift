//
//  LocationServiceTests.swift
//  YourWeatherTests
//
//  Created by Julian Martinez on 9/23/24.
//

import XCTest
import CoreLocation
@testable import YourWeather

final class LocationServiceTests: XCTestCase {
    var locationService: LocationServiceMock!

    override func setUp() {
        super.setUp()
        locationService = LocationServiceMock()
    }

    override func tearDown() {
        locationService = nil
        super.tearDown()
    }

    func testGetCurrentLocationSuccess() {
        // Given
        let expectedCoordinate = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
        locationService.coordinateResult = .success(expectedCoordinate)

        let expectation = XCTestExpectation(description: "Location fetched")

        // When
        locationService.getCurrentLocation { result in
            // Then
            switch result {
            case .success(let coordinate):
                XCTAssertEqual(coordinate.latitude, expectedCoordinate.latitude)
                XCTAssertEqual(coordinate.longitude, expectedCoordinate.longitude)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testGetCurrentLocationFailure() {
        // Given
        locationService.coordinateResult = .failure(LocationError.noAuthorization)

        let expectation = XCTestExpectation(description: "Location fetch failed")

        // When
        locationService.getCurrentLocation { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error is LocationError)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
