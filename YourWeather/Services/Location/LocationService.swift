//
//  LocationService.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/23/24.
//

import CoreLocation
import Foundation

protocol LocationServiceProtocol {
    var isLocationFeatureEnabled: Bool { get set }
    func getCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void)
}

class LocationService: NSObject, LocationServiceProtocol {
    var isLocationFeatureEnabled = false

    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func getCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        locationCompletion = completion

        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            completion(.failure(LocationError.noAuthorization))
        }
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            isLocationFeatureEnabled = true
            break

        case .restricted, .denied:
            isLocationFeatureEnabled = false
            break

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break

        default:
            break
        }
    }
}

enum LocationError: Error {
    case noLocationData
    case noAuthorization
}
