//
//  DessertsService.swift
//  Just Desserts
//
//  Created by Mark Granoff on 6/10/24.
//

import Foundation

/// Desserts Service
class DessertsService: DessertsServiceProviding {
    let networkService: NetworkServiceProviding

    init(networkService: any NetworkServiceProviding) {
        self.networkService = networkService
    }

    enum Constants {
        static let dessertsURL = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        static let lookupURL = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php")!

        static let maxIngredientIndex = 20

        enum Fields {
            static let mealId = "idMeal"
            static let name = "strMeal"
            static let instructions = "strInstructions"
            static let thumbnail = "strMealThumb"
            static let tags = "strTags"
            static let youTubeLink = "strYoutube"
            static let ingredientPrefix = "strIngredient"
            static let measurePrefix = "strMeasure"
        }
    }

    enum Errors: Error {
        case badURL
        case recipeNotFound
    }
    
    /// Return a list of desserts
    /// - Returns: a `MealsModel` struct containing an array of `MealModel` structs
    func getDesserts() async throws -> MealsModel {
        try await networkService.get(url: Constants.dessertsURL)
    }
    
    /// Return a `RecipeModel` for a given meal id.
    /// - Parameter id: the id of the meal recipe to return
    /// - Returns: a `RecipeModel`
    ///
    /// The API returns a sub-optimally arranged data set, essentially a dictionary of strings
    /// which itself is decodable as such (a `[String: String?]` dictionary), but which is not
    /// itself very useful or handy. So this method manipulates the returned dictionary in order
    /// to return a model that is far more useful and friendly to use.
    func lookupDessert(with id: String) async throws -> RecipeModel {
        var urlComponents = URLComponents(string: Constants.lookupURL.absoluteString)
        urlComponents?.queryItems = [URLQueryItem(name: "i", value: id)]
        guard let url = urlComponents?.url else { throw Errors.badURL }

        let recipes: RecipesModel = try await networkService.get(url: url)

        guard let recipe = recipes.recipes.first else { throw Errors.recipeNotFound }

        return recipeModel(for: recipe)
    }
    
    /// Return a `RecipeModel` constructed from a dictionary of values
    /// - Parameter recipe: A `[String: String?]` dictionary
    /// - Returns: A fully-formed more friendly `RecipeModel` struct
    func recipeModel(for recipe: [String: String?]) -> RecipeModel {
        // Pull out the things we want to display. Array elements are optionally returned in general
        // but these array elements, if present are optional. So in lieu of an actual value, fallback
        // to the empty string. This simplifies constructing and then working with the resulting
        // `IngredientModel` later.
        let mealId = recipe[Constants.Fields.mealId] as? String ?? ""
        let name = recipe[Constants.Fields.name] as? String ?? ""
        let instructions = recipe[Constants.Fields.instructions] as? String ?? ""
        let thumbnail = recipe[Constants.Fields.thumbnail] as? String ?? ""
        let tags = recipe[Constants.Fields.tags] as? String ?? ""
        let youTubeLink = recipe[Constants.Fields.youTubeLink] as? String ?? ""

        // Look through all the ingredients to form up a usable model. The ingredient/measure values
        // are separate strings, each. 🤦🏻‍♂️ For example, `strIngredient1`, `strMeasure1`, etc. This code
        // creates an array of `IngredientModel` structs, which we pass into the `RecipeModel` constructor.
        let ingredients: [IngredientModel] = (1...Constants.maxIngredientIndex).compactMap { index in
            guard let ingredient = recipe["\(Constants.Fields.ingredientPrefix)\(index)"] as? String,
                  let measure = recipe["\(Constants.Fields.measurePrefix)\(index)"] as? String,
                  ingredient.isEmpty == false,
                  measure.isEmpty == false else { return nil }
            return IngredientModel(ingredient: ingredient, measure: measure)
        }

        return RecipeModel(mealId: mealId,
                           name: name,
                           instructions: instructions,
                           thumbnail: thumbnail,
                           tags: tags,
                           youTubeLink: youTubeLink,
                           ingredients: ingredients)
    }

}
