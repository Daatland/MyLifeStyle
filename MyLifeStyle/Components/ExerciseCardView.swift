import SwiftUI

struct ExerciseCardView: View {
    @State private var showingExerciseList = false
    
    var exercises: [Exercise]
    var selectedWeek: Date

    // Filtrerer økter som er i inneværende uke
    private var thisWeekExercises: [Exercise] {
        let calendar = Calendar.current
        guard let week = calendar.dateInterval(of: .weekOfYear, for: selectedWeek) else { return [] }
        return exercises.filter { week.contains($0.date) }
    }

    // Totalt antall minutter denne uken
    private var totalMinutesThisWeek: Int {
        thisWeekExercises.reduce(0) { $0 + $1.minutes }
    }

    // Totalt antall økter denne uken
    private var totalSessionsThisWeek: Int {
        thisWeekExercises.count
    }

    // Foreløpig definisjon for de andre sidene
    private let pages: [[(title: String, subtitle: String?, icon: String?)]] = [
        [("Økter", nil, "bolt.fill"), ("Minutter", nil, "clock")],
        [("Volum", nil, "figure.strengthtraining.traditional"), ("Distanse", nil, "figure.run")],
        [("PR-er", nil, "rosette"), ("Streak", nil, "flame.fill")]
    ]
    
    var body: some View {
        TabView {
            ForEach(0..<pages.count, id: \.self) { index in
                HStack(spacing: 12) {
                    if index == 0 {
                        // Første side: Økter og Minutter (med ekte data)
                        MiniStatCard(
                            title: "Økter",
                            subtitle: "\(totalSessionsThisWeek)",
                            icon: "bolt.fill",
                        ) {
                            showingExerciseList = true
                        }
                        MiniStatCard(
                            title: "Minutter",
                            subtitle: "\(totalMinutesThisWeek)",
                            icon: "clock",
                            action: nil
                        )
                    } else {
                        // Andre sider (foreløpig tomme placeholders)
                        let left = pages[index][0]
                        let right = pages[index][1]
                        MiniStatCard(title: left.title, subtitle: left.subtitle, icon: left.icon, action: nil)
                        MiniStatCard(title: right.title, subtitle: right.subtitle, icon: right.icon, action: nil)
                    }
                }
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .tabViewStyle(.page)
                .scrollTargetBehavior(.paging)
            }
        }
        .frame(height: 160)
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: .automatic))
        .padding(.horizontal, -8)
        
        .sheet(isPresented: $showingExerciseList) {
            NavigationStack {
                ExerciseListView()
            }
        }

    }
}

private struct MiniStatCard: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let action: (() -> Void)?
    
    var body: some View {
        Button(action: { action?() }) {
            VStack(alignment: .leading, spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(24)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Cards Pager", traits: .sizeThatFitsLayout) {
    // Eksempeldata for forhåndsvisning
    let exampleExercises = [
        Exercise(name: "Jogging", minutes: 30, intensity: 5, category: .cardio, date: Date()),
        Exercise(name: "Styrke", minutes: 45, intensity: 8, category: .strength, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
        Exercise(name: "Yoga", minutes: 20, intensity: 3, category: .mobility, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)
    ]
    
    // Viser nåværende uke (du kan endre til en testuke om du vil)
    let testWeek = Date()
    
    ExerciseCardView(exercises: exampleExercises, selectedWeek: testWeek)
        .padding()
}
