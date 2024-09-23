//
//  LocationServiceMock.swift
//  YourWeatherTests
//
//  Created by Julian Martinez on 9/23/24.
//

import CoreLocation

class LocationServiceMock: LocationServiceProtocol {
    var isLocationFeatureEnabled: Bool = true
    var coordinateResult: Result<CLLocationCoordinate2D, Error>?

    func getCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        if let result = coordinateResult {
            completion(result)
        } else {
            completion(.failure(LocationError.noLocationData))
        }
    }
}
