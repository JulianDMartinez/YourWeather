//
//  APIClientMock.swift
//  YourWeatherTests
//
//  Created by Julian Martinez on 9/23/24.
//

import Foundation

class APIClientMock: APIClientProtocol {
    var result: Result<Data, Error>?
    var urlRequest: URLRequest?

    func performRequest<T>(with urlRequest: URLRequest) async throws -> T where T: Decodable {
        self.urlRequest = urlRequest
        if let result = result {
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                return try decoder.decode(T.self, from: data)
            case .failure(let error):
                throw error
            }
        } else {
            throw APIError.invalidResponse
        }
    }

    func performDataRequest(with urlRequest: URLRequest) async throws -> Data {
        self.urlRequest = urlRequest
        if let result = result {
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                throw error
            }
        } else {
            throw APIError.invalidResponse
        }
    }
}
