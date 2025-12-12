import SwiftUI

struct CalorieCardView: View {
    var totalCalories: Int
    var goal: Int

    private var progress: Double {
        min(Double(totalCalories) / Double(goal), 1.0)
    }

    private var remaining: Int {
        max(goal - totalCalories, 0)
    }

    var body: some View {
        HStack {
            // venstre side: progress ring
            ProgressRingView(progress: progress, remaining: remaining)
                .frame(width: 160, height: 160)

            // høyre side: tekstinformasjon
            VStack(alignment: .leading, spacing: 8) {
                Text("Kalorier")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Mål: \(goal)")
                    .foregroundColor(.secondary)

                Text("Inntatt: \(totalCalories)")
                    .foregroundColor(.secondary)

                
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 180) // større høyde
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}
