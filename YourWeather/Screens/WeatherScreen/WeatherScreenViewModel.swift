//
//  WeatherScreenViewModel.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/23/24.
//

import Foundation

/*
 Importing swiftUI to allow simple image caching using UIImage and NSCache.
 Alternatively with more time we could implement a custom SwiftUI component that includes caching or use
 a library such as Nuke.
 */
import SwiftUI

/*
 For expediency, handled errors with the displayed error message or via print statements. Alternatively
 user facing errors can be displayed with alerts and logged using an OSLog implementation and a remote
 logging service.
 */
@Observable
@MainActor
class WeatherScreenViewModel {
    var weatherResponse: WeatherResponse?
    var weatherIcon: UIImage?
    var isLoading = false
    var errorMessage: String?
    var city: String = ""

    private let weatherService: WeatherServiceProtocol
    let locationService: LocationServiceProtocol
    private let iconCache = NSCache<NSString, UIImage>()

    init(weatherService: WeatherServiceProtocol, locationService: LocationServiceProtocol) {
        self.weatherService = weatherService
        self.locationService = locationService
    }

    func fetchWeatherByCity() async {
        isLoading = true
        errorMessage = nil

        do {
            let geocodingResults = try await weatherService.geocode(cityName: city)
            
            /*
             For expediency I'm fetching the weather with the first result. With more time, I would display
             the full list of results to the user, and allow them to select a city from the list.
             
             I would also implement textfield input debounce using async sequence and the async algorithms
             package, to display the fetched list every time the user stops typing. This would replace the
             Search button with a single tap in the list.
             */
            
            guard let location = geocodingResults.first else {
                throw WeatherServiceError.cityNotFound
            }
            let data = try await weatherService.fetchWeather(
                forLatitude: location.latitude,
                longitude: location.longitude
            )
            weatherResponse = data
            await getWeatherIcon()
            saveLastSearchedCity(city)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func fetchWeatherByLocationForStartUp() {
        /*
         For expediency treating the initial start up as location services not enabled condition.
         The user can click the Use Current Location button if they want to see the current location
         on after initial start up.

         With more time, I would create an async sequence in locationService that would yield the current
         location after authorization is updated in initial start up. This implementation with async
         sequence would need to account for any conflicts with the user's use of the search field.
          */
        guard locationService.isLocationFeatureEnabled else { return }
        fetchWeatherByLocation()
    }

    func fetchWeatherByLocationForInteraction() {
        /*
         For expediency I'm handling denied authorization with this error message. With more time I would
         provide a link directly to the App's settings.
         */
        guard locationService.isLocationFeatureEnabled else {
            errorMessage = "Location services isn't currently enabled. Please enable location " +
                "services under Settings -> YourWeather to use the current location."
            return
        }

        fetchWeatherByLocation()
    }

    private func fetchWeatherByLocation() {
        isLoading = true
        errorMessage = nil

        locationService.getCurrentLocation { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(coordinate):
                Task {
                    do {
                        let data = try await self.weatherService.fetchWeather(
                            forLatitude: coordinate.latitude,
                            longitude: coordinate.longitude
                        )
                        self.weatherResponse = data
                        await self.getWeatherIcon()
                        self.city = self.weatherResponse?.name ?? "Current Location"
                        self.saveLastSearchedCity(self.city)
                    } catch {
                        self.errorMessage = error.localizedDescription
                    }
                    self.isLoading = false
                }
            case let .failure(error):
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    private func getWeatherIcon() async {
        guard let iconCode = weatherResponse?.weather.first?.icon else { return }

        if let cachedIcon = iconCache.object(forKey: iconCode as NSString) {
            weatherIcon = cachedIcon
            return
        }

        do {
            let data = try await weatherService.fetchWeatherIcon(iconCode: iconCode)
            if let image = UIImage(data: data) {
                iconCache.setObject(image, forKey: iconCode as NSString)
                weatherIcon = image
            }
        } catch {
            print(
                "Image for weather response could not be fetched. \(String(describing: weatherResponse)) " +
                    "Error: \(error)"
            )
        }
    }

    /*
     Using UserDefaults directly since this is a single key value pair save and search.
     For more complex persistence, I would extract this logic into a persistence dedicated object.
    */
    func loadLastSearchedCity() {
        if let lastCity = UserDefaults.standard.string(forKey: "LastSearchedCity") {
            city = lastCity
            Task {
                await fetchWeatherByCity()
            }
        } else {
            fetchWeatherByLocationForStartUp()
        }
    }

    private func saveLastSearchedCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: "LastSearchedCity")
    }
}
