import Foundation
import SwiftData

@Model
final class Artwork {
    var title: String
    var artworkDescription: String
    var tagsText: String
    var archiveDate: Date
    var imageFilename: String
    var createdAt: Date
    var updatedAt: Date
    @Relationship(inverse: \Child.artworks)
    var child: Child?

    var tags: [String] {
        get {
            tagsText
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
        set {
            tagsText = newValue
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
        }
    }

    init(
        title: String = "",
        artworkDescription: String = "",
        tags: [String] = [],
        archiveDate: Date = .now,
        imageFilename: String,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        child: Child? = nil
    ) {
        self.title = title
        self.artworkDescription = artworkDescription
        self.tagsText = tags
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
        self.archiveDate = archiveDate
        self.imageFilename = imageFilename
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.child = child
    }
}
