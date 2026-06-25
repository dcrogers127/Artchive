import SwiftData
import SwiftUI

struct ChildrenView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Child.name) private var children: [Child]

    @State private var isShowingAddChild = false
    @State private var childToEdit: Child?
    @State private var childPendingDeletion: Child?

    var body: some View {
        NavigationStack {
            Group {
                if children.isEmpty {
                    ContentUnavailableView(
                        "No Children Yet",
                        systemImage: "person.crop.circle.badge.plus",
                        description: Text("Add a child profile before archiving artwork.")
                    )
                } else {
                    List {
                        ForEach(children) { child in
                            Button {
                                childToEdit = child
                            } label: {
                                ChildRowView(child: child)
                            }
                            .buttonStyle(.plain)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    childPendingDeletion = child
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                Button {
                                    childToEdit = child
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Children")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddChild = true
                    } label: {
                        Label("Add Child", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddChild) {
                ChildFormView(mode: .add) { formData in
                    addChild(using: formData)
                }
            }
            .sheet(item: $childToEdit) { child in
                ChildFormView(mode: .edit(child)) { formData in
                    update(child, using: formData)
                }
            }
            .alert(
                "Delete Child?",
                isPresented: isShowingDeleteConfirmation,
                presenting: childPendingDeletion
            ) { child in
                Button("Delete", role: .destructive) {
                    delete(child)
                }
                Button("Cancel", role: .cancel) {
                    childPendingDeletion = nil
                }
            } message: { child in
                Text(deletionMessage(for: child))
            }
        }
    }

    private var isShowingDeleteConfirmation: Binding<Bool> {
        Binding(
            get: { childPendingDeletion != nil },
            set: { isPresented in
                if !isPresented {
                    childPendingDeletion = nil
                }
            }
        )
    }

    private func addChild(using formData: ChildFormData) {
        let child = Child(
            name: formData.name,
            birthdate: formData.optionalBirthdate,
            profileColor: formData.profileColor
        )
        modelContext.insert(child)
        saveContext()
    }

    private func update(_ child: Child, using formData: ChildFormData) {
        child.name = formData.name
        child.birthdate = formData.optionalBirthdate
        child.profileColor = formData.profileColor
        saveContext()
    }

    private func delete(_ child: Child) {
        modelContext.delete(child)
        saveContext()
        childPendingDeletion = nil
    }

    private func deletionMessage(for child: Child) -> String {
        let artworkCount = child.artworks.count

        if artworkCount == 0 {
            return "This removes \(child.name)'s profile."
        }

        let entryText = artworkCount == 1 ? "entry" : "entries"
        return "This removes \(child.name)'s profile and \(artworkCount) saved artwork \(entryText)."
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            assertionFailure("Failed to save child profile changes: \(error)")
        }
    }
}

private struct ChildRowView: View {
    let child: Child

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(ChildProfileColor.color(for: child.profileColor))
                .frame(width: 34, height: 34)
                .overlay {
                    Text(initial)
                        .font(.headline)
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(child.name)
                    .font(.body)
                    .foregroundStyle(.primary)

                Text(detailText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }

    private var initial: String {
        child.name.first.map { String($0).uppercased() } ?? "?"
    }

    private var detailText: String {
        let artworkCount = child.artworks.count
        let artworkText = "\(artworkCount) artwork \(artworkCount == 1 ? "entry" : "entries")"

        guard let birthdate = child.birthdate else {
            return artworkText
        }

        return "\(birthdate.formatted(date: .abbreviated, time: .omitted)) - \(artworkText)"
    }
}
