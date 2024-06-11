//
//  NetworkService.swift
//  Just Desserts
//
//  Created by Mark Granoff on 6/10/24.
//

import Foundation

/// Network Service
class NetworkService: NetworkServiceProviding {
    
    /// Fetch the contents of an URL assumed to provide JSON and that is decodable into a knowwn type `T`
    /// - Parameter url: The URL from which to fetch JSON
    /// - Returns: an object of type `T` or throws an error
    func get<T: Decodable>(url: URL) async throws -> T {
        let data = try await fetch(url: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
    
    /// Fetch the contents of an URL and simply return the content as `Data`
    /// - Parameter url: The URL from which to fetch data
    /// - Returns: a `Data` object of throws an error
    func fetch(url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
