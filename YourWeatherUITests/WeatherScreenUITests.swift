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
        app.launchArguments += ["--uitesting", "--resetUserDefaults"]
        app.launch()
    }
    
    /*
     This test is an example for demonstration only. Needs additional set up to assert the UI correctly
     given more time.
     */
    func testNavigationToWeatherScreen() {
        // Verify Home Screen is displayed
        XCTAssertTrue(app.staticTexts["Welcome to Your Weather App"].exists)

        // Tap on "Go to Weather" button
        app.buttons["Go to Weather"].tap()

        // Verify Weather Screen is displayed
        XCTAssertTrue(app.staticTexts["Search for a city to get weather information."].waitForExistence(timeout: 5))
    }

    func testBackToHome() {
        app.buttons["Go to Weather"].tap()
        app.buttons["Back to Home"].tap()
        XCTAssertTrue(app.staticTexts["Welcome to Your Weather App"].exists)
    }
}

