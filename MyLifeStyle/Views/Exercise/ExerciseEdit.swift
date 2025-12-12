import SwiftUI
import SwiftData

struct ExerciseEdit: View {
    @Bindable var exercise: Exercise   // ikke @Binding lenger
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Rediger økt")) {
                TextField("Navn", text: $exercise.name)
                Stepper("Minutter: \(exercise.minutes)", value: $exercise.minutes, in: 5...180, step: 5)
                Stepper("Intensitet: \(exercise.intensity)", value: $exercise.intensity, in: 1...5)
            }
        }
        .navigationTitle("Rediger")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Lagre") {
                    dismiss()   // endringer lagres automatisk
                }
            }
        }
    }
}

