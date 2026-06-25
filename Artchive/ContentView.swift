import SwiftUI

struct ContentView: View {
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
    }
}
