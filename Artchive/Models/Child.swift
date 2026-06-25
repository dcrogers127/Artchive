import Foundation
import SwiftData

@Model
final class Child {
    var id: UUID
    var name: String
    var birthdate: Date?
    var profileColor: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade)
    var artworks: [Artwork]

    init(
        id: UUID = UUID(),
        name: String,
        birthdate: Date? = nil,
        profileColor: String = "blue",
        createdAt: Date = .now,
        artworks: [Artwork] = []
    ) {
        self.id = id
        self.name = name
        self.birthdate = birthdate
        self.profileColor = profileColor
        self.createdAt = createdAt
        self.artworks = artworks
    }
}
