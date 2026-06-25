import SwiftUI
import UIKit

struct AddArtworkView: View {
    let pendingImage: PendingArtworkImage
    let children: [Child]
    let onSave: (ArtworkFormData) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var formData: ArtworkFormData

    init(
        pendingImage: PendingArtworkImage,
        children: [Child],
        onSave: @escaping (ArtworkFormData) -> Void
    ) {
        self.pendingImage = pendingImage
        self.children = children
        self.onSave = onSave
        _formData = State(initialValue: ArtworkFormData(selectedChildID: children.first?.id))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Image(uiImage: pendingImage.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 260)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Section {
                    Picker("Child", selection: $formData.selectedChildID) {
                        ForEach(children) { child in
                            Text(child.name)
                                .tag(Optional(child.id))
                        }
                    }

                    DatePicker(
                        "Archive Date",
                        selection: $formData.archiveDate,
                        displayedComponents: .date
                    )
                }

                Section {
                    TextField("Title", text: $formData.title)

                    TextField("Description", text: $formData.artworkDescription, axis: .vertical)
                        .lineLimit(3...6)

                    TextField("Tags", text: $formData.tagsText)
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("Add Artwork")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(formData.normalized())
                        dismiss()
                    }
                    .disabled(!formData.isValid)
                }
            }
        }
    }
}

struct ArtworkFormData {
    var selectedChildID: UUID?
    var archiveDate = Date()
    var title = ""
    var artworkDescription = ""
    var tagsText = ""

    var isValid: Bool {
        selectedChildID != nil
    }

    var tags: [String] {
        tagsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    func normalized() -> ArtworkFormData {
        var copy = self
        copy.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        copy.artworkDescription = artworkDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        copy.tagsText = tags.joined(separator: ", ")
        return copy
    }
}
