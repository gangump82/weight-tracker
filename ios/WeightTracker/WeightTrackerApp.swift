import SwiftUI

@main
struct WeightTrackerApp: App {
    @StateObject private var viewModel = WeightViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
