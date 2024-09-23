//
//  GlobalSettings.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/22/24.
//

import Foundation

/*
    Provided environemnt configuration for demonstration puposes. With more time we could set up a CI
    pipeline that run tests in debug configuration on each PR. If backend has separate environments
    configured, we would assign environment specific values for the base url and api keys.
 */
enum BuildEnvironemnt: String {
    case dev
    case qa
    case prod
}

// Made as enum to prevent unintended instances. GlobalSettings isn't intended to be initialized.
enum GlobalSettings {
    static let environemnt: BuildEnvironemnt = {
        guard let rawEnvironemnt = Bundle.main.infoDictionary?["APP_ENVIRONMENT"] as? String,
              let environment = BuildEnvironemnt(rawValue: rawEnvironemnt) else {
            // The app should not run if rawEnvironment is nil, as it needs the base URL to function.
            preconditionFailure("rawEnvironemnt must not be nil")
        }
        
        return environemnt
    }()
    
    static let openWeatherBasePath = {
        guard let basePath = Bundle.main.infoDictionary?["OPEN_WEATHER_BASE_URL"] as? String else {
            // The app should not run if openWeatherBasePath is nil, as it needs the base URL to function.
            preconditionFailure("openWeatherBasePath must not be nil")
        }
        return basePath
    }()
    
    static let openWeatherIconBasePath = {
        guard let basePath = Bundle.main.infoDictionary?["OPEN_WEATHER_ICON_BASE_URL"] as? String else {
            // The app should not run if openWeatherBasePath is nil, as it needs the base URL to function.
            preconditionFailure("openWeatherIconBasePath must not be nil")
        }
        return basePath
    }()
    
    /*
        SecretValues is pursperfully not included in repo to not include API key. Depending on the key's risk
        we may not want to include the key in the mobile client's bundle and instead implement a backend
        secure proxy solution.
     */
    static let openWeatherAPIKey = SecretValues.openWeatherAPIKey
}
