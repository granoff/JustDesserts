//
//  MockNetworkService.swift
//  MockNetworkService
//
//  Created by Mark Granoff on 6/10/24.
//

import Foundation

class MockNetworkService: NetworkServiceProviding {

    enum Errors: Error {
        case getFailed
        case fetchFailed
    }

    var getCalled = false
    var getReturnValue: Any?
    public func get<T: Decodable>(url: URL) async throws -> T {
        getCalled = true
        if let getReturnValue = getReturnValue as? T {
            return getReturnValue
        }
        throw Errors.getFailed
    }
    
    var fetchCalled = false
    var fetchReturnValue: Data?
    public func fetch(url: URL) async throws -> Data {
        fetchCalled = true
        if let fetchReturnValue {
            return fetchReturnValue
        }
        throw Errors.fetchFailed
    }
}
