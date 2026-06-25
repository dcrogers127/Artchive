import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Child.createdAt) private var children: [Child]

    var body: some View {
        TabView {
            NavigationStack {
                GalleryPlaceholderView(childCount: children.count)
                    .navigationTitle("Gallery")
            }
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

private struct GalleryPlaceholderView: View {
    let childCount: Int

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(.tint)

            VStack(spacing: 8) {
                Text("Artchive")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Text("A local archive for the artwork worth keeping close.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Text("\(childCount) child profile\(childCount == 1 ? "" : "s") ready")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
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
