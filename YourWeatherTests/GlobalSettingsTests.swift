//
//  YourWeatherTests.swift
//  YourWeatherTests
//
//  Created by Julian Martinez on 9/22/24.
//

import XCTest
@testable import YourWeather

final class GlobalSettingsTests: XCTestCase {

    func testInfoPlistCustomKeysExist() {
        // Get the path to the Info.plist file in the test bundle
        guard let infoPlistURL = Bundle(for: type(of: self)).url(forResource: "Info", withExtension: "plist")
        else {
            XCTFail("Could not find Info.plist in test bundle")
            return
        }

        // Load the Info.plist file into a dictionary
        guard let infoPlistData = try? Data(contentsOf: infoPlistURL) else {
            XCTFail("Could not load Info.plist data")
            return
        }

        var format = PropertyListSerialization.PropertyListFormat.xml
        guard let infoDictionary = try? PropertyListSerialization.propertyList(
            from: infoPlistData,
            options: .mutableContainersAndLeaves,
            format: &format
        ) as? [String: Any] else {
            XCTFail("Could not parse Info.plist")
            return
        }

        // Check that the required keys exist
        XCTAssertNotNil(infoDictionary["APP_ENVIRONMENT"], "APP_ENVIRONMENT key is missing in Info.plist")
        XCTAssertNotNil(
            infoDictionary["OPEN_WEATHER_BASE_URL"],
            "OPEN_WEATHER_BASE_URL key is missing in Info.plist"
        )
        XCTAssertNotNil(
            infoDictionary["OPEN_WEATHER_ICON_BASE_URL"],
            "OPEN_WEATHER_ICON_BASE_URL key is missing in Info.plist"
        )
    }

    func testGlobalSettingsValuesAccessDoNotThrow() {
        // Ensure that GlobalSettings can access the keys correctly
        XCTAssertNoThrow({
            _ = GlobalSettings.environemnt
            _ = GlobalSettings.openWeatherBasePath
        }, "GlobalSettings failed to access the keys in Info.plist")
    }
}
