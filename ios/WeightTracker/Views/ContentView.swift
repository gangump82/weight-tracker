import SwiftUI

enum Tab: String, CaseIterable {
    case weight = "体重"
    case exercise = "运动"
    case diet = "饮食"
    case nutritionist = "营养师"
    case stats = "统计"
    
    var icon: String {
        switch self {
        case .weight: return "scalemass"
        case .exercise: return "figure.run"
        case .diet: return "leaf"
        case .nutritionist: return "person.fill"
        case .stats: return "chart.bar"
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: WeightViewModel
    @State private var selectedTab: Tab = .weight
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                WeightScreen(viewModel: viewModel)
                    .tag(Tab.weight)
                    .tabItem {
                        Label(Tab.weight.rawValue, systemImage: Tab.weight.icon)
                    }
                
                ExerciseScreen(viewModel: viewModel)
                    .tag(Tab.exercise)
                    .tabItem {
                        Label(Tab.exercise.rawValue, systemImage: Tab.exercise.icon)
                    }
                
                DietScreen(viewModel: viewModel)
                    .tag(Tab.diet)
                    .tabItem {
                        Label(Tab.diet.rawValue, systemImage: Tab.diet.icon)
                    }
                
                NutritionistScreen(viewModel: viewModel)
                    .tag(Tab.nutritionist)
                    .tabItem {
                        Label(Tab.nutritionist.rawValue, systemImage: Tab.nutritionist.icon)
                    }
                
                StatsScreen(viewModel: viewModel)
                    .tag(Tab.stats)
                    .tabItem {
                        Label(Tab.stats.rawValue, systemImage: Tab.stats.icon)
                    }
            }
            .tint(.purple)
        }
    }
}
