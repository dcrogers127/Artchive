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

    func saveImageData(_ data: Data, fileExtension: String) throws -> String {
        let filename = makeFilename(fileExtension: fileExtension)
        let destinationURL = try url(for: filename)
        try data.write(to: destinationURL, options: .atomic)
        return filename
    }
}
