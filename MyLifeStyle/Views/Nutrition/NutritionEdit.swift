//
//  NutritionEdit.swift
//  MyLifeStyle
//
//  Created by Marcus Olsen Daatland on 02/10/2025.
//

import SwiftUI
import SwiftData

struct NutritionEdit: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var meal: Nutrition
    
    @State private var tempFood = ""
    @State private var tempCalories = 0
    @State private var tempCategory: NutritionCategory = .frokost

    var body: some View {
        Form {
            Section("Måltid") {
                Picker("Måltid", selection: $tempCategory) {
                    ForEach(NutritionCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Mat") {
                TextField("Hva spiste du?", text: $tempFood)
            }

            Section("Kalorier") {
                TextField("Kalorier", value: $tempCalories, format: .number)
                    .keyboardType(.numberPad)
            }
        }
        .navigationTitle("Rediger måltid")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Lagre") { saveChanges() }
            }
        }
        .onAppear {
            // fyll inn eksisterende data når viewet åpnes
            tempFood = meal.food
            tempCalories = meal.calories
            tempCategory = meal.category
        }
    }

    private func saveChanges() {
        meal.food = tempFood
        meal.calories = tempCalories
        meal.category = tempCategory
        try? context.save()
        dismiss()
    }
}
