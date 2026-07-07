import Foundation

struct MarkdownFile: Identifiable, Hashable {
    let id: String
    let url: URL
    let relativePath: String
    let title: String
    var modifiedAt: Date

    init(url: URL, workspaceURL: URL) {
        let normalizedURL = PathUtilities.normalized(url)
        let normalizedWorkspaceURL = PathUtilities.normalized(workspaceURL)
        self.url = normalizedURL
        self.relativePath = PathUtilities.relativePath(from: normalizedWorkspaceURL, to: normalizedURL)
        self.title = normalizedURL.deletingPathExtension().lastPathComponent
        self.id = relativePath
        self.modifiedAt = (try? normalizedURL.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date()
    }
}
