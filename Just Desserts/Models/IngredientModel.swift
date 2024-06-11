//
//  IngredientModel.swift
//  Just Desserts
//
//  Created by Mark Granoff on 6/10/24.
//

import Foundation

struct IngredientModel: Identifiable {
    let id = UUID()
    let ingredient: String
    let measure: String
}
