import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Child.createdAt) private var children: [Child]

    var body: some View {
        NavigationStack {
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

                    Text("\(children.count) child profile\(children.count == 1 ? "" : "s") ready")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .navigationTitle("Gallery")
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
