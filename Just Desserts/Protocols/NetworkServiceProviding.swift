//
//  NetworkServiceProviding.swift
//  Just Desserts
//
//  Created by Mark Granoff on 6/10/24.
//

import Foundation

public protocol NetworkServiceProviding {
    func get<T: Decodable>(url: URL) async throws -> T
    func fetch(url: URL) async throws -> Data
}

public protocol NetworkServiceDependency {
    var networkService: any NetworkServiceProviding { get }
}
