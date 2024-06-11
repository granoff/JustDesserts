//
//  DessertDetailView.swift
//  Just Desserts
//
//  Created by Mark Granoff on 6/10/24.
//

import Foundation
import SwiftUI

enum DetailViewState {
    case loading
    case loaded
    case error(Error)
}

struct DetailViewModel {
    var state = DetailViewState.loading
    var recipe: RecipeModel?

    var thumbnailURL: URL? {
        guard let thumbnail = recipe?.thumbnail else { return nil }
        return URL(string: thumbnail)
    }

    var name: String {
        recipe?.name ?? ""
    }

    var ingredients: [IngredientModel] {
        recipe?.ingredients ?? []
    }

    var instructions: [String] {
        guard let instructions = recipe?.instructions else { return [] }
        if #available(iOS 16, *) {
            let regex = /\r\n/
            return instructions.split(separator: regex).map { String($0) }
        } else {
            return [instructions]
        }
    }
}

struct DessertDetailView: View {
    var dessertsService: DessertsServiceProviding
    var mealId: String
    @State var model = DetailViewModel(state: .loading)

    enum Constants {
        // We'd want to localize these...
        static let ingredients = "Ingredients"
        static let instructions = "Instructions"
    }

    var body: some View {
        switch model.state {
            case .loading:
                ProgressView()
                    .task {
                        do {
                            let recipe = try await dessertsService.lookupDessert(with: mealId)
                            model = DetailViewModel(recipe: recipe)
                            model.state = .loaded
                        } catch {
                            model.state = .error(error)
                        }
                    }

            case .loaded:
                ScrollView {
                    AsyncImage(url: model.thumbnailURL) { image in
                        image.image?.resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    Spacer()

                    HStack {
                        Text(Constants.ingredients)
                            .font(.title2)
                        Spacer()
                    }

                    ForEach(model.ingredients, id: \.id) { item in
                        HStack {
                            Text(item.measure)
                            Text(item.ingredient)
                        }
                    }
                    Spacer()

                    HStack {
                        Text(Constants.instructions)
                            .font(.title2)
                        Spacer()
                    }

                    ForEach(model.instructions, id: \.self) { line in
                        // This HStack solves an odd layout issue which prevented the text from aligning left, even with .frame(alignment:) modifiers.
                        // Placing the Text() inside an HStack like this, with a "trailing" Spacer() lets all the text align left nicely.
                        HStack {
                            Text(line)
                            Spacer()
                        }
                        .padding(.bottom, 8)
                    }
                }
                .navigationTitle(model.name)
                .navigationBarTitleDisplayMode(.inline)

            case .error(let error):
                Text(error.localizedDescription)
        }
    }
}

#Preview {
    DessertDetailView(dessertsService: AppDependencies().dessertsService, mealId: "52928")
}
