//
//  MealtModel.swift
//  Just Desserts
//
//  Created by Mark Granoff on 6/10/24.
//

import Foundation

struct MealModel: Decodable, Identifiable {
    let id: String
    let name: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case thumbnail = "strMealThumb"
        case id = "idMeal"
    }
}

struct MealsModel: Decodable {
    var meals: [MealModel]
}
