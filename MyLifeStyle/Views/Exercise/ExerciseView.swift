import SwiftUI
import SwiftData

struct ExerciseView: View {
    @Binding var plusTrigger: Bool
    
    @Query var exercises: [Exercise]
    @Environment(\.modelContext) var context
    
    @State private var selectedWeek: Date = Date()
    @State private var showingAdd = false
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: previousWeek) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                        }
                        Spacer()
                        Text("Uke \(Calendar.current.component(.weekOfYear, from: selectedWeek))")
                            .font(.headline)
                        Spacer()
                        Button(action: nextWeek) {
                            Image(systemName: "chevron.right")
                                .font(.title3)
                        }
                    }
                    .padding(.horizontal)

                    ExerciseWeeklyCardView(exercises: exercises, selectedWeek: selectedWeek)
                    
                    ExerciseCardView(exercises: exercises, selectedWeek: selectedWeek)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    AppNavLogo()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
            .sheet(isPresented: $plusTrigger) {
                ExerciseAdd()
            }
            
        }
    }
    private func previousWeek() {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedWeek) {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedWeek = newDate
            }
        }
    }


    private func nextWeek() {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedWeek) {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedWeek = newDate
            }
        }
    }
}

#Preview {
    ExerciseView(plusTrigger: .constant(false))
        .modelContainer(for: Exercise.self, inMemory: true)
}

