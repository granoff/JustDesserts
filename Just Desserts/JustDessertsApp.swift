//
//  JustDessertsApp.swift
//  Just Desserts
//
//  Created by Mark Granoff on 6/10/24.
//

import SwiftUI

@main
struct JustDessertsApp: App {
    var body: some Scene {
        WindowGroup {
            DessertsView(dependencies: AppDependencies())
        }
    }
}

typealias AppDependenciesProviding = NetworkServiceDependency & DessertsServiceDependency

class AppDependencies: AppDependenciesProviding {
    var networkService: any NetworkServiceProviding
    var dessertsService: any DessertsServiceProviding

    init() {
        networkService = NetworkService()
        dessertsService = DessertsService(networkService: networkService)
    }
}
