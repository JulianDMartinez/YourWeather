//
//  APIClient.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/23/24.
//

import Foundation

protocol APIClientProtocol {
    func performRequest<T: Decodable>(with urlRequest: URLRequest) async throws -> T
}

class APIClient: APIClientProtocol {
    func performRequest<T: Decodable>(with urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              200 ..< 300 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

enum APIError: Error {
    case invalidResponse
    case decodingError(Error)
}
