import SwiftUI

@main
struct ADHDAcceleratorApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: [TaskGroup.self, TaskItem.self])
    }
}

#Preview {
    MainView()
        .modelContainer(for: [TaskGroup.self, TaskItem.self])
}
