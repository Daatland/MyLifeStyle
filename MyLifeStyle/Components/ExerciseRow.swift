//
import SwiftUI
import SwiftData

struct ExerciseRow: View {
    var exercise: Exercise
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                // Navn på økten
                Text(exercise.name)
                    .font(.headline)
                
                // Minutter + intensitet
                Text("\(exercise.minutes) min – Intensitet: \(exercise.intensity)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Kategori (enum)
                Text("Kategori: \(exercise.category.rawValue)")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

