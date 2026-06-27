import Foundation

struct VersionHistoryStore {
    let workspaceURL: URL

    var sidecarURL: URL {
        workspaceURL.appendingPathComponent(".graft", isDirectory: true)
    }

    var historyURL: URL {
        sidecarURL.appendingPathComponent("history", isDirectory: true)
    }

    func prepare() {
        try? FileManager.default.createDirectory(at: historyURL, withIntermediateDirectories: true)
        try? FileManager.default.createDirectory(at: sidecarURL.appendingPathComponent("shares", isDirectory: true), withIntermediateDirectories: true)
    }

    func snapshot(file: MarkdownFile, content: String, reason: String, source: String) -> VersionSnapshot? {
        prepare()
        let folderName = safeName(file.relativePath)
        let folderURL = historyURL.appendingPathComponent(folderName, isDirectory: true)
        try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)

        let timestamp = Date()
        let id = Self.snapshotIDFormatter.string(from: timestamp)
        let snapshotURL = folderURL.appendingPathComponent("\(id).md")
        let header = """
        ---
        graft_document: \(file.relativePath)
        graft_source: \(source)
        graft_reason: \(reason)
        graft_created_at: \(ISO8601DateFormatter().string(from: timestamp))
        ---

        """
        do {
            try (header + content).write(to: snapshotURL, atomically: true, encoding: .utf8)
            return VersionSnapshot(
                id: id,
                documentPath: file.relativePath,
                snapshotURL: snapshotURL,
                timestamp: timestamp,
                source: source,
                reason: reason,
                byteCount: content.utf8.count
            )
        } catch {
            return nil
        }
    }

    func snapshots(for file: MarkdownFile) -> [VersionSnapshot] {
        let folderURL = historyURL.appendingPathComponent(safeName(file.relativePath), isDirectory: true)
        guard let urls = try? FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: [.contentModificationDateKey]) else {
            return []
        }

        return urls
            .filter { $0.pathExtension == "md" }
            .compactMap { url in
                let date = (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date()
                let content = (try? String(contentsOf: url, encoding: .utf8)) ?? ""
                let reason = frontMatterValue("graft_reason", in: content) ?? "Checkpoint"
                let source = frontMatterValue("graft_source", in: content) ?? "Graft"
                return VersionSnapshot(
                    id: url.deletingPathExtension().lastPathComponent,
                    documentPath: file.relativePath,
                    snapshotURL: url,
                    timestamp: date,
                    source: source,
                    reason: reason,
                    byteCount: content.utf8.count
                )
            }
            .sorted { $0.timestamp > $1.timestamp }
    }

    func restoreContent(from snapshot: VersionSnapshot) -> String? {
        guard let raw = try? String(contentsOf: snapshot.snapshotURL, encoding: .utf8) else {
            return nil
        }
        if raw.hasPrefix("---"), let range = raw.range(of: "\n---\n\n") {
            return String(raw[range.upperBound...])
        }
        return raw
    }

    private func safeName(_ path: String) -> String {
        path.replacingOccurrences(of: "/", with: "__")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ".", with: "_")
    }

    private func frontMatterValue(_ key: String, in content: String) -> String? {
        content.components(separatedBy: .newlines)
            .first { $0.hasPrefix("\(key): ") }?
            .replacingOccurrences(of: "\(key): ", with: "")
    }

    private static let snapshotIDFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss-SSS"
        return formatter
    }()
}
