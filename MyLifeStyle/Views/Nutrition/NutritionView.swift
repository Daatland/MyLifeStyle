import SwiftUI
import SwiftData

struct NutritionView: View {
    @Binding var plusTrigger: Bool
    
    @State private var selectedDate: Date = Date()
    @State private var showingMealSelection = false
    @State private var selectedCategory: NutritionCategory? = nil
    @State private var showingMealList = false
    
    @Environment(\.modelContext) private var context
    @Query private var meals: [Nutrition]
    
    @AppStorage("dailyCalorieGoal") private var dailyGoal: Int = 2500
    
    // filtrer måltider per valgt dato
    var filteredMeals: [Nutrition] {
        meals.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    // summering for dashboard
    var totalCalories: Int {
        filteredMeals.reduce(0) { $0 + $1.calories }
    }
    
    var totalMeals: Int {
        filteredMeals.count
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing:20) {
                HStack {
                    Button(action: goToPreviousDay) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .frame(width: 47)
                    }

                    Spacer()

                    Text(selectedDate, style: .date)
                        .font(.headline)

                    Spacer()

                    Button(action: goToNextDay) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .frame(width: 47)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                
                
                CalorieCardView(totalCalories: totalCalories, goal: dailyGoal)
                    .padding(.horizontal)
                
                // dashboard-bokser
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    NutritionCardView(
                        title: "Måltider",
                        subtitle: "\(totalMeals) registrert",
                        icon: "fork.knife",
                        action: { showingMealList = true }
                    )
                    NutritionCardView(
                        title: "Skritt",
                        subtitle: "0 / 10 000",
                        icon: "figure.walk",
                        action: { print("Skritt trykket") }
                    )
                    NutritionCardView(
                        title: "Vekt",
                        subtitle: "Siste 90 dager",
                        icon: "scalemass",
                        action: { print("Vekt trykket") }
                    )
                    NutritionCardView(
                        title: "Middagstips",
                        subtitle: "Sunnere utvalg",
                        icon: "carrot",
                        action: { print("Middagstips trykket") }
                    )
                }
                .padding()
                
                
                .onChange(of: plusTrigger) {
                    if plusTrigger {
                        showingMealSelection = true
                        plusTrigger = false
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    AppNavLogo()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            
            
            .sheet(isPresented: $showingMealList) {
                MealListView(selectedDate: selectedDate)
            }
            
            // Først: velg måltid
            .sheet(isPresented: $showingMealSelection) {
                MealSelectionView(selectedCategory: $selectedCategory)
            }
            
            // Så: åpne NutritionAdd for den valgte kategorien
            .sheet(item: $selectedCategory) { category in
                NutritionAdd(category: category, date: selectedDate)
            }
        }
    }
    private func goToPreviousDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedDate = newDate
            }
        }
    }
    private func goToNextDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedDate = newDate
            }
        }
    }
}

#Preview("Nutrition", traits: .sizeThatFitsLayout) {
    NutritionView(plusTrigger: .constant(false))
        .modelContainer(for: Nutrition.self, inMemory: true)
}
