import XCTest
@testable import GraftCore

final class AgentInstructionsWriterTests: XCTestCase {
    func testWritesPlainMarkdownEditingContract() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        let writer = AgentInstructionsWriter(workspaceURL: root)

        let url = try writer.write()
        let text = try String(contentsOf: url, encoding: .utf8)

        XCTAssertEqual(url.lastPathComponent, "AGENTS.md")
        XCTAssertTrue(text.contains("Keep Markdown files as plain text."))
        XCTAssertTrue(text.contains(".pagepacket/changes"))
        XCTAssertTrue(text.contains("Do not rewrite unrelated sections."))
    }
}
