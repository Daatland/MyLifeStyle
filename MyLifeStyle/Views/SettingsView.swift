import SwiftUI

struct SettingsView: View {
    // Utseende
    @AppStorage("isDarkMode") private var isDarkMode = false

    // Målverdier
    @AppStorage("dailyCalorieGoal") private var dailyCalorieGoal: Int = 2500
    @AppStorage("weeklyMinutesGoal") private var weeklyMinutesGoal: Int = 150

    // Midlertidig input (for trygg validering via TextField)
    @State private var calorieText: String = ""
    @State private var minutesText: String = ""

    var body: some View {
        Form {
            Section(header: Text("Utseende")) {
                Toggle(isOn: $isDarkMode) {
                    Label("Dark Mode", systemImage: "moon.fill")
                }
                .accessibilityLabel("Dark Mode")
            }

            Section(header: Text("Mål – Kosthold")) {
                HStack {
                    Text("Daglig kalori-mål")
                    Spacer()
                    TextField("", text: $calorieText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 100)
                        .onChange(of: calorieText) { _, new in
                            let v = Int(new.filter(\.isNumber)) ?? dailyCalorieGoal
                            dailyCalorieGoal = max(0, min(v, 100000))
                            if String(v) != new { calorieText = String(v) }
                        }
                        .onAppear { calorieText = String(dailyCalorieGoal) }
                        .accessibilityLabel("Daglig kalori-mål")
                }
                Stepper(value: $dailyCalorieGoal, in: 0...100000, step: 50) {
                    Text("\(dailyCalorieGoal) kcal")
                        .foregroundColor(.secondary)
                }
                .onChange(of: dailyCalorieGoal) { _, v in
                    calorieText = String(v)
                }
            }

            Section(header: Text("Mål – Trening (per uke)")) {
                HStack {
                    Text("Minutter")
                    Spacer()
                    TextField("", text: $minutesText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 100)
                        .onChange(of: minutesText) { _, new in
                            let v = Int(new.filter(\.isNumber)) ?? weeklyMinutesGoal
                            weeklyMinutesGoal = max(0, min(v, 10000))
                            if String(v) != new { minutesText = String(v) }
                        }
                        .onAppear { minutesText = String(weeklyMinutesGoal) }
                        .accessibilityLabel("Ukentlig treningsminutter")
                }
                Stepper(value: $weeklyMinutesGoal, in: 0...10000, step: 10) {
                    Text("\(weeklyMinutesGoal) min")
                        .foregroundColor(.secondary)
                }
                .onChange(of: weeklyMinutesGoal) { _, v in
                    minutesText = String(v)
                }
            }

            Section {
                Button(role: .destructive) {
                    resetToDefaults()
                } label: {
                    Label("Tilbakestill til standardverdier", systemImage: "arrow.counterclockwise")
                }
                .accessibilityLabel("Tilbakestill til standardverdier")
            }
        }
        .navigationTitle("Innstillinger")
    }

    private func resetToDefaults() {
        dailyCalorieGoal = 2500
        weeklyMinutesGoal = 150
        calorieText = String(dailyCalorieGoal)
        minutesText = String(weeklyMinutesGoal)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
