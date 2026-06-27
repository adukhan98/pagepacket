import XCTest
@testable import GraftCore

final class ChangeMetadataStoreTests: XCTestCase {
    func testReadsAgentMetadataFromGraftChangesFolder() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        let changes = root.appendingPathComponent(".graft/changes", isDirectory: true)
        try FileManager.default.createDirectory(at: changes, withIntermediateDirectories: true)
        try """
        {
          "filePath": "README.md",
          "agent": "codex",
          "summary": "Tightened introduction"
        }
        """.write(to: changes.appendingPathComponent("20260620-codex.json"), atomically: true, encoding: .utf8)

        let metadata = ChangeMetadataStore(workspaceURL: root).metadata(for: "README.md")

        XCTAssertEqual(metadata?.agent, "codex")
        XCTAssertEqual(metadata?.summary, "Tightened introduction")
    }

    func testMissingMetadataReturnsFallbackValues() {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        let fallback = ChangeMetadataStore(workspaceURL: root).fallbackMetadata(for: "README.md")

        XCTAssertEqual(fallback.filePath, "README.md")
        XCTAssertEqual(fallback.agent, "external")
        XCTAssertEqual(fallback.summary, "External edit detected")
    }
}
