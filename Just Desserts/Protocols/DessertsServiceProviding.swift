//
//  DessertsServiceProviding.swift
//  Just Desserts
//
//  Created by Mark Granoff on 6/10/24.
//

import Foundation

protocol DessertsServiceProviding {
    func getDesserts() async throws -> MealsModel
    func lookupDessert(with id: String) async throws -> RecipeModel
}

protocol DessertsServiceDependency {
    var dessertsService: DessertsServiceProviding { get }
}
