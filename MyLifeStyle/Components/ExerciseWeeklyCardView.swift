import SwiftUI
import SwiftData

struct ExerciseWeeklyCardView: View {
    var exercises: [Exercise]
    var selectedWeek: Date
    
    // Henter alle datoene (man–søn) for inneværende uke
    private var currentWeekDays: [Date] {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedWeek) else { return [] }
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: weekInterval.start)
        }
    }

    
    // Summerer minutter trent per dag
    private var minutesPerDay: [Int] {
        let calendar = Calendar.current
        
        return currentWeekDays.map { day in
            let sameDayExercises = exercises.filter { calendar.isDate($0.date, inSameDayAs: day) }
            return sameDayExercises.reduce(0) { $0 + $1.duration }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Minutter denne uken")
                .font(.headline)

            // Stolpegraf (mandag–søndag)
            GeometryReader { geo in
                HStack(alignment: .bottom, spacing: 8) {
                    // Venstre Y-akse
                    VStack(alignment: .trailing, spacing: 0) {
                        ForEach(Array(stride(from: 180, through: 0, by: -30)), id: \.self) { value in
                            Text("\(value)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .frame(height: 30, alignment: .bottom)
                        }
                    }
                    .frame(width: 30)
                    .padding(.trailing, 4)
                    
                    // Stolpediagram (mandag–søndag)
                    HStack(alignment: .bottom, spacing: 12) {
                        ForEach(Array(minutesPerDay.enumerated()), id: \.offset) { index, minutes in
                            let maxHeight: CGFloat = 120
                            let normalized = CGFloat(minutes) / 180.0 // 180 = maksverdi på y-aksen

                            VStack {
                                Capsule()
                                    .fill(Color.blue)
                                    .frame(width: 16,height: maxHeight * normalized)
                                Text(shortDay(for: index))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(height: 180)
            } //  Lukker GeometryReader riktig her
            .frame(height: 190)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

        
        // Forkorter ukedagene (starter på mandag)
        private func shortDay(for index: Int) -> String {
            let symbols = Calendar.current.shortWeekdaySymbols // ["Sun", "Mon", ...]
            let reordered = Array(symbols[1...6]) + [symbols[0]] // starter på mandag
            return reordered[index]
        }
    }
    
    

