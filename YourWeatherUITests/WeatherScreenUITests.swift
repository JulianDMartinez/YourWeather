//
//  WeatherScreenUITests.swift
//  YourWeatherUITests
//
//  Created by Julian Martinez on 9/23/24.
//

import XCTest

// These are examples of UI tests for demonstration only. These need additional set up assert the UI correctly
// given more time.
final class WeatherScreenUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    func testSearchCityWeather() {
        // Given
        let cityName = "London"
        let searchField = app.textFields["Enter city name"]
        let searchButton = app.buttons["Search"]

        // When
        searchField.tap()
        searchField.typeText(cityName)
        searchButton.tap()

        // Then
        let cityLabel = app.staticTexts[cityName]
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: cityLabel
        )

        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(result, .completed, "City label did not appear in time")
    }

    func testUseCurrentLocationButton() {
        // Given
        let useLocationButton = app.buttons["Use Current Location"]

        // When
        useLocationButton.tap()

        // Then
        // Assuming the app will show weather information for the current location
        let cityLabel = app.staticTexts["Current Location"]
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: cityLabel
        )

        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(result, .completed, "Current location weather did not appear in time")
    }
}

