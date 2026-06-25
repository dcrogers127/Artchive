import SwiftUI

enum ChildProfileColor: String, CaseIterable, Identifiable {
    case blue
    case green
    case orange
    case pink
    case purple

    var id: String { rawValue }

    var name: String {
        switch self {
        case .blue:
            "Blue"
        case .green:
            "Green"
        case .orange:
            "Orange"
        case .pink:
            "Pink"
        case .purple:
            "Purple"
        }
    }

    var color: Color {
        switch self {
        case .blue:
            .blue
        case .green:
            .green
        case .orange:
            .orange
        case .pink:
            .pink
        case .purple:
            .purple
        }
    }

    static func color(for rawValue: String) -> Color {
        ChildProfileColor(rawValue: rawValue)?.color ?? .blue
    }
}

