import Foundation

public struct AgentInstructionsWriter {
    public let workspaceURL: URL

    public init(workspaceURL: URL) {
        self.workspaceURL = workspaceURL
    }

    @discardableResult
    public func write() throws -> URL {
        try FileManager.default.createDirectory(at: workspaceURL, withIntermediateDirectories: true)
        let url = workspaceURL.appendingPathComponent("AGENTS.md", isDirectory: false)
        try Self.contents.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    @discardableResult
    public func writeIfMissing() throws -> URL {
        let url = workspaceURL.appendingPathComponent("AGENTS.md", isDirectory: false)
        guard !FileManager.default.fileExists(atPath: url.path) else {
            return url
        }
        return try write()
    }

    public static let contents = """
    # Pagepacket Editing Contract

    Keep Markdown files as plain text.
    Make the smallest scoped edit that satisfies the request.
    Do not rewrite unrelated sections.
    Preserve the user's wording unless the request asks for a rewrite.
    When possible, describe your edit in `.pagepacket/changes/<timestamp>-<agent>.json`.

    Metadata JSON shape:

    ```json
    {
      "filePath": "README.md",
      "agent": "codex",
      "summary": "Tightened introduction"
    }
    ```

    """
}
