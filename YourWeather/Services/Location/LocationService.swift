//
//  LocationService.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/23/24.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func requestLocationPermission()
    func getCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void)
}

class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func getCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        locationCompletion = completion
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate Conformance
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationCompletion?(.success(location.coordinate))
        } else {
            locationCompletion?(.failure(LocationError.noLocationData))
        }
        locationCompletion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(.failure(error))
        locationCompletion = nil
    }
}

enum LocationError: Error {
    case noLocationData
}
