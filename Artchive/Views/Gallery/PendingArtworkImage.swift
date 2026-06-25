import Foundation
import UIKit

struct PendingArtworkImage: Identifiable {
    let id = UUID()
    let data: Data
    let image: UIImage
    let fileExtension: String
}
