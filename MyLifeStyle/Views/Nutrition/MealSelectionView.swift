import SwiftUI

struct MealSelectionView: View {
    @Binding var selectedCategory: NutritionCategory?
    @Environment(\.dismiss) private var dismiss   
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(NutritionCategory.allCases) { category in
                    Button(category.rawValue) {
                        selectedCategory = category   // setter kategori
                        dismiss()                    // lukker MealSelection
                    }
                }
            }
            .navigationTitle("Velg måltid")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                }

            }
        }
    }
}
