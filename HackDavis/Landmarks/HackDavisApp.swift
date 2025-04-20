import SwiftUI

@main
struct HackDavisApp: App {
    @StateObject private var userData = UserData()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environmentObject(userData)
            }
        }
    }
}
