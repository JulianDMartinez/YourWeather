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
            let isUITesting = CommandLine.arguments.contains("--uitesting")
            let container = isUITesting ? DIContainer.makeMock() : DIContainer.makeDefault()
            RootCoordinatorView(container: container)
        }
    }
}
