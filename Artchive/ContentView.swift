import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            GalleryView()
            .tabItem {
                Label("Gallery", systemImage: "photo.on.rectangle.angled")
            }

            ChildrenView()
                .tabItem {
                    Label("Children", systemImage: "person.2")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: [
                Child.self,
                Artwork.self
            ], inMemory: true)
    }
}
