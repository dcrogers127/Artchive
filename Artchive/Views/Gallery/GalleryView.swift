import PhotosUI
import SwiftData
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct GalleryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Child.name) private var children: [Child]
    @Query(sort: \Artwork.archiveDate, order: .reverse) private var artworks: [Artwork]

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var pendingArtworkImage: PendingArtworkImage?
    @State private var errorMessage: String?

    private let imageStore = ImageStore()

    var body: some View {
        NavigationStack {
            Group {
                if children.isEmpty {
                    ContentUnavailableView(
                        "Add a Child First",
                        systemImage: "person.crop.circle.badge.plus",
                        description: Text("Create a child profile before archiving artwork.")
                    )
                } else if artworks.isEmpty {
                    ContentUnavailableView(
                        "No Artwork Yet",
                        systemImage: "photo.on.rectangle.angled",
                        description: Text("Import the first piece from your photo library.")
                    )
                } else {
                    List {
                        ForEach(artworks) { artwork in
                            ArtworkRowView(artwork: artwork)
                        }
                    }
                }
            }
            .navigationTitle("Gallery")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label("Add Artwork", systemImage: "plus")
                    }
                    .disabled(children.isEmpty)
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    await prepareArtworkImage(from: newItem)
                }
            }
            .sheet(item: $pendingArtworkImage) { pendingImage in
                AddArtworkView(
                    pendingImage: pendingImage,
                    children: children
                ) { formData in
                    saveArtwork(from: pendingImage, formData: formData)
                }
            }
            .alert("Artwork Could Not Be Saved", isPresented: isShowingError) {
                Button("OK", role: .cancel) {
                    errorMessage = nil
                }
            } message: {
                Text(errorMessage ?? "Please try again.")
            }
        }
    }

    private var isShowingError: Binding<Bool> {
        Binding(
            get: { errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    errorMessage = nil
                }
            }
        )
    }

    @MainActor
    private func prepareArtworkImage(from item: PhotosPickerItem?) async {
        guard let item else { return }

        defer {
            selectedPhotoItem = nil
        }

        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                errorMessage = "The selected image could not be loaded."
                return
            }

            pendingArtworkImage = PendingArtworkImage(
                data: data,
                image: image,
                fileExtension: fileExtension(for: item)
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func saveArtwork(from pendingImage: PendingArtworkImage, formData: ArtworkFormData) {
        guard let selectedChildID = formData.selectedChildID,
              let child = children.first(where: { $0.id == selectedChildID }) else {
            errorMessage = "Select a child before saving artwork."
            return
        }

        do {
            let imageFilename = try imageStore.saveImageData(
                pendingImage.data,
                fileExtension: pendingImage.fileExtension
            )

            let artwork = Artwork(
                title: formData.title,
                artworkDescription: formData.artworkDescription,
                tags: formData.tags,
                archiveDate: formData.archiveDate,
                imageFilename: imageFilename,
                child: child
            )

            modelContext.insert(artwork)
            try modelContext.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func fileExtension(for item: PhotosPickerItem) -> String {
        if item.supportedContentTypes.contains(where: { $0.conforms(to: .jpeg) }) {
            return "jpg"
        }

        if item.supportedContentTypes.contains(where: { $0.conforms(to: .png) }) {
            return "png"
        }

        if item.supportedContentTypes.contains(where: { $0.conforms(to: .heic) }) {
            return "heic"
        }

        return "img"
    }
}

private struct ArtworkRowView: View {
    let artwork: Artwork

    var body: some View {
        HStack(spacing: 12) {
            ArtworkThumbnail(imageFilename: artwork.imageFilename)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)

                Text(detailText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }

    private var title: String {
        artwork.title.isEmpty ? "Untitled Artwork" : artwork.title
    }

    private var detailText: String {
        let dateText = artwork.archiveDate.formatted(date: .abbreviated, time: .omitted)

        if let childName = artwork.child?.name {
            return "\(childName) - \(dateText)"
        }

        return dateText
    }
}

private struct ArtworkThumbnail: View {
    let imageFilename: String

    private let imageStore = ImageStore()

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.secondary.opacity(0.12))
            }
        }
        .frame(width: 58, height: 58)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var image: UIImage? {
        guard let url = try? imageStore.url(for: imageFilename) else {
            return nil
        }

        return UIImage(contentsOfFile: url.path)
    }
}
