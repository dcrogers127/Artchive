import SwiftUI
import SwiftData

@main
struct ArtchiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Child.self,
            Artwork.self
        ])
    }
}
