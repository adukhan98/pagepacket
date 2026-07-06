import XCTest
@testable import GraftCore

final class MarkdownPatchEngineTests: XCTestCase {
    func testAppliesChangedParagraphHunk() throws {
        let current = "# Title\n\nOld paragraph.\n\nDone."
        let range = ChangeRange(
            oldStartLine: 3,
            oldEndLine: 3,
            newStartLine: 3,
            newEndLine: 3,
            kind: .paragraph,
            before: "Old paragraph.",
            after: "New paragraph."
        )

        let result = try MarkdownPatchEngine().apply(range, to: current)

        XCTAssertEqual(result, "# Title\n\nNew paragraph.\n\nDone.")
    }

    func testAppliesInsertedBlockHunk() throws {
        let current = "# Title\n\nDone."
        let range = ChangeRange(
            oldStartLine: 3,
            oldEndLine: 3,
            newStartLine: 3,
            newEndLine: 5,
            kind: .paragraph,
            before: "",
            after: "New paragraph.\n"
        )

        let result = try MarkdownPatchEngine().apply(range, to: current)

        XCTAssertEqual(result, "# Title\n\nNew paragraph.\n\nDone.")
    }

    func testAppliesDeletedBlockHunk() throws {
        let current = "# Title\n\nRemove me.\n\nDone."
        let range = ChangeRange(
            oldStartLine: 3,
            oldEndLine: 3,
            newStartLine: 3,
            newEndLine: 3,
            kind: .paragraph,
            before: "Remove me.",
            after: ""
        )

        let result = try MarkdownPatchEngine().apply(range, to: current)

        XCTAssertEqual(result, "# Title\n\nDone.")
    }

    func testRefusesStaleHunkWhenCurrentTextDoesNotMatchBeforeBlock() {
        let current = "# Title\n\nHuman paragraph.\n\nDone."
        let range = ChangeRange(
            oldStartLine: 3,
            oldEndLine: 3,
            newStartLine: 3,
            newEndLine: 3,
            kind: .paragraph,
            before: "Old paragraph.",
            after: "Agent paragraph."
        )

        XCTAssertThrowsError(try MarkdownPatchEngine().apply(range, to: current)) { error in
            XCTAssertEqual(error as? MarkdownPatchError, .staleHunk)
        }
    }

    func testAppliesHunkWhenPriorAcceptedHunkShiftedLineNumbers() throws {
        let current = "# Title\n\nInserted earlier.\n\nOld paragraph.\n\nDone."
        let range = ChangeRange(
            oldStartLine: 3,
            oldEndLine: 3,
            newStartLine: 3,
            newEndLine: 3,
            kind: .paragraph,
            before: "Old paragraph.",
            after: "New paragraph."
        )

        let result = try MarkdownPatchEngine().apply(range, to: current)

        XCTAssertEqual(result, "# Title\n\nInserted earlier.\n\nNew paragraph.\n\nDone.")
    }
}
