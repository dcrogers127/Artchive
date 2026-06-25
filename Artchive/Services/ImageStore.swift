import Foundation

struct ImageStore {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    var artworkDirectory: URL {
        get throws {
            let documentsDirectory = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let directory = documentsDirectory.appendingPathComponent("ArtworkImages", isDirectory: true)

            if !fileManager.fileExists(atPath: directory.path) {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            }

            return directory
        }
    }

    func url(for filename: String) throws -> URL {
        try artworkDirectory.appendingPathComponent(filename)
    }

    func makeFilename(fileExtension: String = "jpg") -> String {
        "\(UUID().uuidString).\(fileExtension)"
    }
}

