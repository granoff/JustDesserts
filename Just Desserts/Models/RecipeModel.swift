//
//  RecipeModel.swift
//  Just Desserts
//
//  Created by Mark Granoff on 6/10/24.
//

import Foundation

struct RecipeModel {
    let mealId: String
    let name: String
    let instructions: String
    let thumbnail: String
    let tags: String
    let youTubeLink: String
    let ingredients: [IngredientModel]
}

struct RecipesModel: Decodable {
    let recipes: [[String: String?]]

    enum CodingKeys: String, CodingKey {
        case recipes = "meals"
    }
}
