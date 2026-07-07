import Foundation

public struct ChangeMetadata: Codable, Equatable {
    public let filePath: String
    public let agent: String
    public let summary: String

    public init(filePath: String, agent: String, summary: String) {
        self.filePath = filePath
        self.agent = agent
        self.summary = summary
    }
}

public struct ChangeMetadataStore {
    public let workspaceURL: URL

    public init(workspaceURL: URL) {
        self.workspaceURL = workspaceURL
    }

    public func metadata(for filePath: String) -> ChangeMetadata? {
        let folder = workspaceURL.appendingPathComponent(".pagepacket/changes", isDirectory: true)
        guard let urls = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil) else {
            return nil
        }

        return urls
            .filter { $0.pathExtension == "json" }
            .sorted { $0.lastPathComponent > $1.lastPathComponent }
            .compactMap { url -> ChangeMetadata? in
                guard let data = try? Data(contentsOf: url) else { return nil }
                guard let metadata = try? JSONDecoder().decode(ChangeMetadata.self, from: data) else { return nil }
                return metadata.filePath == filePath ? metadata : nil
            }
            .first
    }

    public func fallbackMetadata(for filePath: String) -> ChangeMetadata {
        ChangeMetadata(filePath: filePath, agent: "external", summary: "External edit detected")
    }
}
