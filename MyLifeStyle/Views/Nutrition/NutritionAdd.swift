//
//  NutritionAdd.swift
//  MyLifeStyle
//
//  Created by Marcus Olsen Daatland on 01/10/2025.
//

import SwiftUI
import SwiftData

struct NutritionAdd: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    let category: NutritionCategory
    let date: Date
    
    @State private var food: String = ""
    @State private var calories: String = ""
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section(header: Text("Måltid")) {
                    Text(category.rawValue)
                        .font(.headline)
                }
                
                Section(header: Text("Mat")) {
                    TextField("Hva spiste du?", text: $food)
                }
                
                Section(header: Text("Kalorier")) {
                    TextField("Kalorier", text: $calories)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Legg til måltid")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Lagre") {
                        saveMeal()
                        dismiss()
                    }
                    .disabled(food.isEmpty || Int(calories) == nil)
                }
            }
        }

                
            }
            
            private func saveMeal () {
                let newMeal = Nutrition(
                    category: category,
                    food: food,
                    calories: Int(calories) ?? 0,
                    date: date
                )
                context.insert(newMeal)
                
                do {
                    try context.save()
                }   catch {
                    print("Feil med lagring")
                }
            }
        }
    
        

