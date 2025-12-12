import SwiftUI
import SwiftData

struct MainView: View {
    @State private var selectedTab = 0
    @State private var nutritionPlusTrigger = false
    @State private var exercisePlusTrigger = false

    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                NavigationView {
                    ExerciseView(plusTrigger:$exercisePlusTrigger)
                }
                .tabItem {
                    Label("Exercise", systemImage: "figure.strengthtraining.traditional")
                }
                .tag(1)
                
                
                NavigationView {
                    NutritionView(plusTrigger:$nutritionPlusTrigger)
                }
                .tabItem {
                    Label("Nutrition", systemImage: "leaf.fill")
                }
                .tag(2)
                
                
                
                NavigationView {
                    SettingsView()
                }
                .tabItem {
                    Label("More", systemImage: "gearshape.fill")
                }
                .tag(3)
            }
            .tint(.blue)
            
            Button(action: handlePlusTap) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .padding(20)
                        .background(Circle().fill(.ultraThickMaterial))
                        .shadow(radius: 6)
                        .padding(.bottom, 15)
                        .offset(y: -5)

                }
                .padding(.bottom, 12)
        }
    }
    
    private func handlePlusTap() {
        switch selectedTab {
        case 1:
            exercisePlusTrigger.toggle()
        case 2:
            nutritionPlusTrigger.toggle()
        default:
            break
        }
    }

}

#Preview {
    MainView()
        .modelContainer(for: Exercise.self, inMemory: true)
}
