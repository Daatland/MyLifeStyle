import SwiftUI
import SwiftData

struct ExerciseAdd: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var name = ""
    @State private var minutes = 30
    @State private var intensity = 3
    @State private var selectedDate: Date = Date()
    
    
    @State private var selectedCategory: ExerciseCategory = .strength
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
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
                
                Form {
                    Section(header: Text("Ny økt")) {
                        TextField("Navn", text: $name)
                        Stepper("Minutter: \(minutes)", value: $minutes, in: 5...180, step: 5)
                        Stepper("Intensitet: \(intensity)", value: $intensity, in: 1...5)
                    }
                    Picker("Kategori", selection: $selectedCategory) {
                        ForEach(ExerciseCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
            }
                .navigationTitle("Legg til økt")
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
                            _ = Calendar.current.startOfDay(for: selectedDate)
                            let newExercise = Exercise(
                                name: name,
                                minutes: minutes,
                                intensity: intensity,
                                category: selectedCategory,
                                date: selectedDate
                            )
                            context.insert(newExercise)
                            do {
                                try context.save()
                                dismiss()
                            } catch {
                                print("Kunne ikke lagre: \(error.localizedDescription)")
                            }
                        }
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
            ExerciseAdd()
                .modelContainer(for: Exercise.self, inMemory: true)
        }
