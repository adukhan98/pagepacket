import XCTest
@testable import GraftCore

final class ChangeSetStoreTests: XCTestCase {
    func testWritesAndReadsPendingChangeSet() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        let store = ChangeSetStore(workspaceURL: root)
        let change = ChangeSet(
            filePath: "README.md",
            authorName: "claude",
            authorKind: .agent,
            status: .pending,
            summary: "Edited intro",
            baseText: "Old",
            proposedText: "New",
            ranges: []
        )

        try store.write(change)
        let loaded = try store.loadAll()

        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded[0].filePath, "README.md")
        XCTAssertEqual(loaded[0].status, .pending)
    }

    func testWritesAcceptedAndRejectedChangeSetsToStatusFolders() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        let store = ChangeSetStore(workspaceURL: root)
        let accepted = ChangeSet(
            filePath: "README.md",
            authorName: "codex",
            authorKind: .agent,
            status: .accepted,
            summary: "Accepted copy edit",
            baseText: "Old",
            proposedText: "New",
            ranges: []
        )
        let rejected = ChangeSet(
            filePath: "README.md",
            authorName: "codex",
            authorKind: .agent,
            status: .rejected,
            summary: "Rejected copy edit",
            baseText: "Old",
            proposedText: "New",
            ranges: []
        )

        try store.write(accepted)
        try store.write(rejected)

        XCTAssertEqual(try store.load(status: .accepted).map(\.id), [accepted.id])
        XCTAssertEqual(try store.load(status: .rejected).map(\.id), [rejected.id])
    }
}
