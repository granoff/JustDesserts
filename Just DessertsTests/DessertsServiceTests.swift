//
//  DessertsServiceTests.swift
//  Just DessertsTests
//
//  Created by Mark Granoff on 6/10/24.
//

import XCTest

final class DessertsServiceTests: XCTestCase {

    var subject: DessertsService!
    var mockNetworkService: MockNetworkService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkService = MockNetworkService()
        subject = DessertsService(networkService: mockNetworkService)
    }

    func testGetDessertsSuccess() async throws {
        mockNetworkService.getReturnValue = try XCTUnwrap(mockMealsModel)
        let result = try await subject.getDesserts()
        XCTAssertEqual(result, try XCTUnwrap(mockNetworkService.getReturnValue as? MealsModel))
    }

    func testGetDessertsFailure() async throws {
        // no return value set
        do {
            _ = try await subject.getDesserts()
            XCTFail()
        } catch {
            XCTAssert(true)
        }
    }

    func testLookupDessertSuccess() async throws {
        mockNetworkService.getReturnValue = mockRecipesModel
        let expected = subject.recipeModel(for: try XCTUnwrap(mockRecipesModel?.recipes.first))
        let result: RecipeModel = try await subject.lookupDessert(with: "foo")
        XCTAssertEqual(result, expected)
    }

    func testLookupDessertFailure() async throws {
        // no return value set
        do {
            _ = try await subject.lookupDessert(with: "foo")
            XCTFail()
        } catch {
            XCTAssert(true)
        }
    }
}

extension MealsModel: Equatable {
    static func ==(lhs: MealsModel, rhs: MealsModel) -> Bool {
        lhs.meals.count == rhs.meals.count
    }
}

extension RecipeModel: Equatable {
    static func ==(lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        lhs.mealId == rhs.mealId &&
        lhs.ingredients.count == 7 && rhs.ingredients.count == 7
    }
}

extension DessertsServiceTests {
    var mockMealsModel: MealsModel? {
        let json = """
{
"meals": [
        {
            "strMeal": "Apam balik",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
            "idMeal": "53049"
        },
        {
            "strMeal": "Apple & Blackberry Crumble",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
            "idMeal": "52893"
        },
        {
            "strMeal": "Apple Frangipan Tart",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
            "idMeal": "52768"
        }
    ]
}
"""
        if let data = json.data(using: .utf8) {
            return try? JSONDecoder().decode(MealsModel.self, from: data)
        }
        return nil
    }

    var mockRecipesModel: RecipesModel? {
        let json = """
{
    "meals": [
        {
            "idMeal": "52910",
            "strMeal": "Chinon Apple Tarts",
            "strDrinkAlternate": null,
            "strCategory": "Dessert",
            "strArea": "French",
            "strInstructions": "To make the red wine jelly, ...",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/qtqwwu1511792650.jpg",
            "strTags": "Tart,Baking",
            "strYoutube": "https://www.youtube.com/watch?v=5dAW9HQgtCk",
            "strIngredient1": "Puff Pastry",
            "strIngredient2": "Dark Brown Soft Sugar",
            "strIngredient3": "Braeburn Apples",
            "strIngredient4": "Red Wine Jelly",
            "strIngredient5": "Creme Fraiche",
            "strIngredient6": "Icing Sugar",
            "strIngredient7": "Cardamom",
            "strIngredient8": "",
            "strIngredient9": "",
            "strIngredient10": "",
            "strMeasure1": "320g",
            "strMeasure2": "4 tbs",
            "strMeasure3": "3",
            "strMeasure4": "4 tbs",
            "strMeasure5": "100ml",
            "strMeasure6": "1 tbs",
            "strMeasure7": "3",
            "strMeasure8": "",
            "strMeasure9": "",
            "strMeasure10": "",
        }
    ]
}
"""
        if let data = json.data(using: .utf8) {
            return try? JSONDecoder().decode(RecipesModel.self, from: data)
        }
        return nil
    }
}
