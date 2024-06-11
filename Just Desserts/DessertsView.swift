//
//  DessertsView.swift
//  Just Desserts
//
//  Created by Mark Granoff on 6/10/24.
//

import SwiftUI

enum DessertsViewState {
    case loading
    case loaded
    case error(Error)
}

struct DessertsViewModel {
    var state = DessertsViewState.loading
    var meals: [MealModel]

    func sortedMeals() -> [MealModel] {
        meals.sorted { a, b in
            a.name < b.name
        }
    }
}

struct DessertsView: View {
    let dependencies: DessertsServiceDependency
    @State var model: DessertsViewModel = .init(meals: [])

    var body: some View {
        VStack {
            switch model.state {
                case .loading:
                    ProgressView()
                        .task {
                            do {
                                let meals = try await dependencies.dessertsService.getDesserts()
                                model = DessertsViewModel(meals: meals.meals)
                                model.state = .loaded
                            } catch {
                                model.state = .error(error)
                            }
                        }
                case .loaded:
                    NavigationView {
                        List(model.sortedMeals(), id: \.id) { meal in
                            NavigationLink(meal.name) {
                                DessertDetailView(dessertsService: dependencies.dessertsService, mealId: meal.id)
                            }
                        }
                        .navigationTitle("Just Desserts")
                    }
                    .listStyle(.plain)
                case .error(let error):
                    Text(error.localizedDescription)
            }
        }
        .padding()
    }
}

#Preview {
    return DessertsView(dependencies: AppDependencies())
}
