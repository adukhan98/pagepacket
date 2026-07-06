import XCTest
@testable import GraftCore

final class MarkdownDiffEngineTests: XCTestCase {
    func testChangedHeadingIsGroupedAsHeading() {
        let engine = MarkdownDiffEngine()
        let ranges = engine.changedRanges(
            before: "# Draft\n\nBody",
            after: "# Final\n\nBody"
        )

        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0].kind, .heading)
        XCTAssertEqual(ranges[0].before, "# Draft")
        XCTAssertEqual(ranges[0].after, "# Final")
    }

    func testChangedParagraphKeepsLineNumbers() {
        let engine = MarkdownDiffEngine()
        let ranges = engine.changedRanges(
            before: "# Title\n\nOld paragraph.\n\nDone.",
            after: "# Title\n\nNew paragraph.\n\nDone."
        )

        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0].oldStartLine, 3)
        XCTAssertEqual(ranges[0].newStartLine, 3)
        XCTAssertEqual(ranges[0].kind, .paragraph)
    }

    func testNoChangeReturnsEmptyRanges() {
        let engine = MarkdownDiffEngine()
        XCTAssertTrue(engine.changedRanges(before: "Same", after: "Same").isEmpty)
    }

    func testMultilineListChangeStaysInOneListBlock() {
        let engine = MarkdownDiffEngine()
        let ranges = engine.changedRanges(
            before: "# Plan\n\n- One\n- Two\n- Three\n\nDone",
            after: "# Plan\n\n- One\n- Two updated\n- Three\n\nDone"
        )

        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0].kind, .list)
        XCTAssertEqual(ranges[0].oldStartLine, 3)
        XCTAssertEqual(ranges[0].oldEndLine, 5)
        XCTAssertEqual(ranges[0].before, "- One\n- Two\n- Three")
        XCTAssertEqual(ranges[0].after, "- One\n- Two updated\n- Three")
    }
}
