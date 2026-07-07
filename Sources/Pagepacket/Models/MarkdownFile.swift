import Foundation

struct MarkdownFile: Identifiable, Hashable {
    let id: String
    let url: URL
    let relativePath: String
    let title: String
    var modifiedAt: Date

    init(url: URL, workspaceURL: URL) {
        self.url = url
        self.relativePath = url.path.replacingOccurrences(of: workspaceURL.path + "/", with: "")
        self.title = url.deletingPathExtension().lastPathComponent
        self.id = relativePath
        self.modifiedAt = (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date()
    }
}
