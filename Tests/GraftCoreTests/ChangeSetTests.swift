import XCTest
@testable import GraftCore

final class ChangeSetTests: XCTestCase {
    func testChangeSetKeepsMarkdownAsTextPayloads() {
        let change = ChangeSet(
            filePath: "README.md",
            authorName: "codex",
            authorKind: .agent,
            status: .pending,
            summary: "Tightened intro",
            baseText: "# Old\n\nBody",
            proposedText: "# New\n\nBody",
            ranges: [
                ChangeRange(
                    oldStartLine: 1,
                    oldEndLine: 1,
                    newStartLine: 1,
                    newEndLine: 1,
                    kind: .heading,
                    before: "# Old",
                    after: "# New"
                )
            ]
        )

        XCTAssertEqual(change.filePath, "README.md")
        XCTAssertEqual(change.authorKind, .agent)
        XCTAssertEqual(change.status, .pending)
        XCTAssertEqual(change.ranges.first?.kind, .heading)
        XCTAssertEqual(change.baseText, "# Old\n\nBody")
        XCTAssertEqual(change.proposedText, "# New\n\nBody")
    }

    func testChangeSetReportsConflictsFromStatusOrRanges() {
        let rangeConflict = ChangeSet(
            filePath: "README.md",
            authorName: "codex",
            authorKind: .agent,
            status: .pending,
            summary: "Overlapping edit",
            baseText: "Old",
            proposedText: "New",
            ranges: [
                ChangeRange(
                    oldStartLine: 1,
                    oldEndLine: 1,
                    newStartLine: 1,
                    newEndLine: 1,
                    kind: .paragraph,
                    before: "Old",
                    after: "New",
                    isConflict: true
                )
            ]
        )

        let statusConflict = ChangeSet(
            filePath: "README.md",
            authorName: "codex",
            authorKind: .agent,
            status: .conflict,
            summary: "Overlapping edit",
            baseText: "Old",
            proposedText: "New",
            ranges: []
        )

        XCTAssertTrue(rangeConflict.hasConflicts)
        XCTAssertTrue(statusConflict.hasConflicts)
    }
}
