//
//  YourWeatherApp.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import SwiftUI

@main
struct YourWeatherApp: App {
    let diContainer = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            WeatherScreen(viewModel: diContainer.weatherScreenVM)
        }
    }
}
