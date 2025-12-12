import SwiftUI
import SwiftData

struct ExerciseListView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate: Date = Date()

    @Query private var exercises: [Exercise]

    var filteredExercises: [Exercise] {
        exercises.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: previousDay) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                }
                Spacer()
                Text(selectedDate, style: .date)
                    .font(.headline)
                Spacer()
                Button(action: nextDay) {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            // Liste over økter
            List {
                if filteredExercises.isEmpty {
                    Text("Ingen økter registrert denne dagen")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(filteredExercises) { exercise in
                        NavigationLink(destination: ExerciseEdit(exercise: exercise)) {
                            ExerciseRow(exercise: exercise)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(filteredExercises[index])
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Økter")
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

    //  Navigasjon mellom dager
    private func previousDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }

    private func nextDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

#Preview {
    ExerciseListView()
        .modelContainer(for: Exercise.self, inMemory: true)
}
