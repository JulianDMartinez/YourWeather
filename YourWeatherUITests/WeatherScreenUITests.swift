//
//  WeatherScreenUITests.swift
//  YourWeatherUITests
//
//  Created by Julian Martinez on 9/23/24.
//

import XCTest


final class WeatherScreenUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    func testNavigationToWeatherScreen() {
        // Verify Home Screen is displayed
        XCTAssertTrue(app.staticTexts["Welcome to Your Weather App"].exists)

        // Tap on "Go to Weather" button
        app.buttons["Go to Weather"].tap()

        // Verify Weather Screen is displayed
        XCTAssertTrue(app.buttons["Use Current Location"].waitForExistence(timeout: 5))
    }

    func testBackToHome() {
        app.buttons["Go to Weather"].tap()
        app.buttons["Back to Home"].tap()
        XCTAssertTrue(app.staticTexts["Welcome to Your Weather App"].exists)
    }
}

