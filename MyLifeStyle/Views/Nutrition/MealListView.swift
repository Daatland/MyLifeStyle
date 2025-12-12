import SwiftUI
import SwiftData

struct MealListView: View {
    let selectedDate: Date
    @Environment(\.modelContext) private var context
    @Query private var meals: [Nutrition]
    @Environment(\.dismiss) private var dismiss

    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        let start = Calendar.current.startOfDay(for: selectedDate)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        _meals = Query(
            filter: #Predicate<Nutrition> { meal in
                meal.date >= start && meal.date < end
            },
            sort: \.date, order: .forward
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                if meals.isEmpty {
                    ContentUnavailableView(
                        "Ingen måltider denne dagen",
                        systemImage: "fork.knife",
                        description: Text("Trykk + nederst for å legge til et måltid.")
                    )
                } else {
                    List {
                        ForEach(meals) { meal in
                            NavigationLink {
                                NutritionEdit(meal: meal)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(meal.food)
                                        .font(.headline)
                                    Text("\(meal.calories) kcal – \(meal.category.rawValue)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                context.delete(meals[index])
                            }
                            try? context.save()
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle(formattedDate(selectedDate))
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

    private func formattedDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df.string(from: date)
    }
}
