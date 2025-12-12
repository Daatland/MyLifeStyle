import SwiftUI
import SwiftData

fileprivate struct ActivityItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let date: Date
    let icon: String

    enum Kind {
        case exercise(Exercise)
        case nutrition(Nutrition)
    }
    let kind: Kind
}

struct HomeView: View {
    @Query private var exercises: [Exercise]
    @Query private var meals: [Nutrition]
    
    @AppStorage("dailyCalorieGoal") private var dailyCalorieGoal: Int = 2000
    @AppStorage("weeklyMinutesGoal") private var weeklyMinutesGoal: Int = 150

    private var weeklyCalorieGoal: Int { dailyCalorieGoal * 7 }

    @State private var selectedWeek: Date = Date()
    
    private var currentWeekInterval: DateInterval? {
        Calendar.current.dateInterval(of: .weekOfYear, for: selectedWeek)
    }
    
    private var totalWeeklyCalories: Int {
        guard let interval = currentWeekInterval else { return 0 }
        return meals
            .filter { interval.contains($0.date) }
            .reduce(0) { $0 + $1.calories }
    }
    
    private var totalWeeklyMinutes: Int {
        guard let interval = currentWeekInterval else { return 0 }
        return exercises
            .filter { interval.contains($0.date) }
            .reduce(0) { $0 + $1.minutes }
    }
    
    private var totalWeeklySessions: Int {
        guard let interval = currentWeekInterval else { return 0 }
        return exercises.filter { interval.contains($0.date) }.count
    }
    
    private var totalMealsThisWeek: Int {
        guard let interval = currentWeekInterval else { return 0 }
        return meals.filter { interval.contains($0.date) }.count
    }

    private var averageCaloriesPerDay: Int {
        guard let interval = currentWeekInterval else { return 0 }
        let mealsThisWeek = meals.filter { interval.contains($0.date) }
        guard !mealsThisWeek.isEmpty else { return 0 }
        let uniqueDays = Set(mealsThisWeek.map { Calendar.current.startOfDay(for: $0.date) })
        let totalCalories = mealsThisWeek.reduce(0) { $0 + $1.calories }
        return totalCalories / max(uniqueDays.count, 1)
    }

    private var averageMinutesPerSession: Int {
        guard let interval = currentWeekInterval else { return 0 }
        let sessionsThisWeek = exercises.filter { interval.contains($0.date) }
        guard !sessionsThisWeek.isEmpty else { return 0 }
        let totalMinutes = sessionsThisWeek.reduce(0) { $0 + $1.minutes }
        return totalMinutes / sessionsThisWeek.count
    }
    
    private var recentActivities: [ActivityItem] {
        let exerciseItems = exercises.map { ex in
            ActivityItem(
                title: ex.name,
                subtitle: "\(ex.minutes) min",
                date: ex.date,
                icon: "figure.strengthtraining.traditional",
                kind: .exercise(ex)
            )
        }

        let mealItems = meals.map { m in
            ActivityItem(
                title: m.food,
                subtitle: "\(m.calories) kcal",
                date: m.date,
                icon: "fork.knife",
                kind: .nutrition(m)
            )
        }

        let combined = exerciseItems + mealItems
        return combined
            .sorted { $0.date > $1.date }
            .prefix(5)
            .map { $0 }
    }
    
    @ViewBuilder
    private func activityDestination(for item: ActivityItem) -> some View {
        switch item.kind {
        case .exercise(let ex):
            ExerciseEdit(exercise: ex)
        case .nutrition(let meal):
            NutritionEdit(meal: meal)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    //  Ukesmål
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ukesmål")
                            .font(.title2).bold()
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal , showsIndicators: false){
                            HStack(spacing: 20) {
                                WeeklyGoalCard(
                                    title: "Kalorier",
                                    value: totalWeeklyCalories,
                                    goal: weeklyCalorieGoal,     // <- dynamisk ukesmål = dagsmål * 7
                                    unit: "kcal"
                                )
                                WeeklyGoalCard(
                                    title: "Trening",
                                    value: totalWeeklyMinutes,
                                    goal: weeklyMinutesGoal,     // <- hentes fra Settings
                                    unit: "min"
                                )
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Denne uken
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Denne uken")
                            .font(.title2).bold()
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                WeeklyStatCard(
                                    title: "Måltider",
                                    value: "\(totalMealsThisWeek)",
                                    icon: "fork.knife"
                                )
                                WeeklyStatCard(
                                    title: "Snitt kcal/dag",
                                    value: "\(averageCaloriesPerDay)",
                                    icon: "flame.fill"
                                )
                                WeeklyStatCard(
                                    title: "Totalt økter",
                                    value: "\(totalWeeklySessions)",
                                    icon: "bolt.fill"
                                )
                                WeeklyStatCard(
                                    title: "Snitt min/økt",
                                    value: "\(averageMinutesPerSession)",
                                    icon: "clock"
                                )
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Siste aktiviteter
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Siste aktiviteter")
                            .font(.title2).bold()
                            .padding(.horizontal)
                        
                        if recentActivities.isEmpty {
                            PlaceholderActivityRow(text: "Ingen aktiviteter enda")
                                .padding(.horizontal)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(recentActivities) { item in
                                    NavigationLink {
                                        activityDestination(for: item)
                                    } label: {
                                        ActivityRow(item: item)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    AppNavLogo()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


private struct WeeklyGoalCard: View {
    let title: String
    let value: Int
    let goal: Int
    let unit: String

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(Double(value) / Double(goal), 1.0)
    }

    private var remaining: Int {
        max(goal - value, 0)
    }

    private var progressText: String {
        let pct = Int(progress * 100)
        switch pct {
        case 100:
            return "🎉 100% nådd – bra jobbet!"
        case 75..<100:
            return "Du nærmer deg målet!"
        case 50..<75:
            return "Over halvveis!"
        default:
            return "Kom igjen, du klarer det!"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.leading, 8)

            HstackRing

            VStack(alignment: .center, spacing: 4) {
                Text("\(value) / \(goal) \(unit)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(progressText)
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40, height: 240)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(radius: 2)
    }

   
    @ViewBuilder
    private var HstackRing: some View {
        HStack {
            Spacer()
            ProgressRingView(progress: progress, remaining: remaining, showPercentage: true)
                .frame(width: 140, height: 115)
            Spacer()
        }
        .padding()
    }
}

private struct WeeklyStatCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(width: UIScreen.main.bounds.width / 2.7, height: 120, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(24)
        .shadow(radius: 2)
    }
}

private struct ActivityRow: View {
    let item: ActivityItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(item.date, format: .dateTime.day().month().year())
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(item.date, style: .time)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(radius: 1)
    }
}


private struct PlaceholderActivityRow: View {
    let text: String
    var body: some View {
        HStack {
            Circle().frame(width: 10, height: 10).foregroundColor(.gray)
            Text(text).foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Exercise.self, Nutrition.self], inMemory: true)
}
