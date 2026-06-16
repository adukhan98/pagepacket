import Foundation

struct VersionSnapshot: Identifiable, Hashable {
    let id: String
    let documentPath: String
    let snapshotURL: URL
    let timestamp: Date
    let source: String
    let reason: String
    let byteCount: Int

    var displayTitle: String {
        "\(source) checkpoint"
    }
}
