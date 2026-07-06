import Foundation
import GraftCore

struct HarnessFailure: Error, CustomStringConvertible {
    let description: String
}

var passed = 0
var failures: [String] = []

@MainActor
func test(_ name: String, _ body: () throws -> Void) {
    do {
        try body()
        passed += 1
        print("PASS \(name)")
    } catch {
        failures.append("\(name): \(error)")
        print("FAIL \(name): \(error)")
    }
}

func expectTrue(_ value: Bool, _ message: String) throws {
    guard value else {
        throw HarnessFailure(description: message)
    }
}

func expectEqual<T: Equatable>(_ actual: T, _ expected: T, _ message: String) throws {
    guard actual == expected else {
        throw HarnessFailure(description: "\(message) (actual: \(actual), expected: \(expected))")
    }
}

func expectThrowsEqual<E: Error & Equatable>(_ expected: E, _ body: () throws -> Void) throws {
    do {
        try body()
        throw HarnessFailure(description: "Expected \(expected) to be thrown")
    } catch let error as E {
        try expectEqual(error, expected, "Thrown error should match")
    }
}

func temporaryWorkspace() throws -> URL {
    let url = FileManager.default.temporaryDirectory
        .appendingPathComponent("graft-behavior-harness-\(UUID().uuidString)", isDirectory: true)
    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    return url
}

test("ChangeSet keeps Markdown payloads and range metadata") {
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

    try expectEqual(change.filePath, "README.md", "file path")
    try expectEqual(change.authorKind, .agent, "author kind")
    try expectEqual(change.status, .pending, "status")
    try expectEqual(change.ranges.first?.kind, .heading, "range kind")
    try expectEqual(change.baseText, "# Old\n\nBody", "base text")
    try expectEqual(change.proposedText, "# New\n\nBody", "proposed text")
}

test("ChangeSet reports conflicts from status or ranges") {
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

    try expectTrue(rangeConflict.hasConflicts, "range conflict should be detected")
    try expectTrue(statusConflict.hasConflicts, "status conflict should be detected")
}

test("ChangeMetadataStore reads agent metadata and fallback values") {
    let root = try temporaryWorkspace()
    let changes = root.appendingPathComponent(".graft/changes", isDirectory: true)
    try FileManager.default.createDirectory(at: changes, withIntermediateDirectories: true)
    try """
    {
      "filePath": "README.md",
      "agent": "codex",
      "summary": "Tightened introduction"
    }
    """.write(to: changes.appendingPathComponent("20260620-codex.json"), atomically: true, encoding: .utf8)

    let store = ChangeMetadataStore(workspaceURL: root)
    let metadata = store.metadata(for: "README.md")
    let fallback = store.fallbackMetadata(for: "GUIDE.md")

    try expectEqual(metadata?.agent, "codex", "metadata agent")
    try expectEqual(metadata?.summary, "Tightened introduction", "metadata summary")
    try expectEqual(fallback.filePath, "GUIDE.md", "fallback path")
    try expectEqual(fallback.agent, "external", "fallback agent")
    try expectEqual(fallback.summary, "External edit detected", "fallback summary")
}

test("AgentInstructionsWriter writes plain Markdown editing contract") {
    let root = try temporaryWorkspace()
    let writer = AgentInstructionsWriter(workspaceURL: root)

    let url = try writer.write()
    let text = try String(contentsOf: url, encoding: .utf8)

    try expectEqual(url.lastPathComponent, "AGENTS.md", "instructions filename")
    try expectTrue(text.contains("Keep Markdown files as plain text."), "plain text guidance")
    try expectTrue(text.contains(".graft/changes"), "metadata guidance")
    try expectTrue(text.contains("Do not rewrite unrelated sections."), "scoped edit guidance")
}

test("MarkdownPatchEngine applies changed, inserted, and deleted hunks safely") {
    let engine = MarkdownPatchEngine()
    let changed = ChangeRange(
        oldStartLine: 3,
        oldEndLine: 3,
        newStartLine: 3,
        newEndLine: 3,
        kind: .paragraph,
        before: "Old paragraph.",
        after: "New paragraph."
    )
    let inserted = ChangeRange(
        oldStartLine: 3,
        oldEndLine: 3,
        newStartLine: 3,
        newEndLine: 5,
        kind: .paragraph,
        before: "",
        after: "New paragraph.\n"
    )
    let deleted = ChangeRange(
        oldStartLine: 3,
        oldEndLine: 3,
        newStartLine: 3,
        newEndLine: 3,
        kind: .paragraph,
        before: "Remove me.",
        after: ""
    )

    try expectEqual(
        try engine.apply(changed, to: "# Title\n\nOld paragraph.\n\nDone."),
        "# Title\n\nNew paragraph.\n\nDone.",
        "changed hunk"
    )
    try expectEqual(
        try engine.apply(inserted, to: "# Title\n\nDone."),
        "# Title\n\nNew paragraph.\n\nDone.",
        "inserted hunk"
    )
    try expectEqual(
        try engine.apply(deleted, to: "# Title\n\nRemove me.\n\nDone."),
        "# Title\n\nDone.",
        "deleted hunk"
    )
}

test("MarkdownPatchEngine refuses stale hunks and relocates unique matches") {
    let engine = MarkdownPatchEngine()
    let stale = ChangeRange(
        oldStartLine: 3,
        oldEndLine: 3,
        newStartLine: 3,
        newEndLine: 3,
        kind: .paragraph,
        before: "Old paragraph.",
        after: "Agent paragraph."
    )
    let shifted = ChangeRange(
        oldStartLine: 3,
        oldEndLine: 3,
        newStartLine: 3,
        newEndLine: 3,
        kind: .paragraph,
        before: "Old paragraph.",
        after: "New paragraph."
    )

    try expectThrowsEqual(MarkdownPatchError.staleHunk) {
        _ = try engine.apply(stale, to: "# Title\n\nHuman paragraph.\n\nDone.")
    }
    try expectEqual(
        try engine.apply(shifted, to: "# Title\n\nInserted earlier.\n\nOld paragraph.\n\nDone."),
        "# Title\n\nInserted earlier.\n\nNew paragraph.\n\nDone.",
        "shifted unique hunk"
    )
}

test("ChangeSetStore writes and reads pending, accepted, and rejected reviews") {
    let root = try temporaryWorkspace()
    let store = ChangeSetStore(workspaceURL: root)
    let pending = ChangeSet(
        filePath: "README.md",
        authorName: "claude",
        authorKind: .agent,
        status: .pending,
        summary: "Edited intro",
        baseText: "Old",
        proposedText: "New",
        ranges: []
    )
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

    try store.write(pending)
    try store.write(accepted)
    try store.write(rejected)

    try expectEqual(try store.load(status: .pending).map(\.id), [pending.id], "pending ids")
    try expectEqual(try store.load(status: .accepted).map(\.id), [accepted.id], "accepted ids")
    try expectEqual(try store.load(status: .rejected).map(\.id), [rejected.id], "rejected ids")
    try expectEqual(try store.loadAll().count, 3, "all reviews count")
}

test("MarkdownDiffEngine groups heading, paragraph, no-op, and list changes") {
    let engine = MarkdownDiffEngine()
    let heading = engine.changedRanges(before: "# Draft\n\nBody", after: "# Final\n\nBody")
    let paragraph = engine.changedRanges(
        before: "# Title\n\nOld paragraph.\n\nDone.",
        after: "# Title\n\nNew paragraph.\n\nDone."
    )
    let list = engine.changedRanges(
        before: "# Plan\n\n- One\n- Two\n- Three\n\nDone",
        after: "# Plan\n\n- One\n- Two updated\n- Three\n\nDone"
    )

    try expectEqual(heading.count, 1, "heading range count")
    try expectEqual(heading[0].kind, .heading, "heading kind")
    try expectEqual(heading[0].before, "# Draft", "heading before")
    try expectEqual(heading[0].after, "# Final", "heading after")
    try expectEqual(paragraph.count, 1, "paragraph range count")
    try expectEqual(paragraph[0].oldStartLine, 3, "paragraph old start")
    try expectEqual(paragraph[0].newStartLine, 3, "paragraph new start")
    try expectEqual(paragraph[0].kind, .paragraph, "paragraph kind")
    try expectTrue(engine.changedRanges(before: "Same", after: "Same").isEmpty, "no-op diff")
    try expectEqual(list.count, 1, "list range count")
    try expectEqual(list[0].kind, .list, "list kind")
    try expectEqual(list[0].oldStartLine, 3, "list old start")
    try expectEqual(list[0].oldEndLine, 5, "list old end")
    try expectEqual(list[0].before, "- One\n- Two\n- Three", "list before")
    try expectEqual(list[0].after, "- One\n- Two updated\n- Three", "list after")
}

if failures.isEmpty {
    print("Graft behavior harness passed \(passed) checks.")
} else {
    fputs("Graft behavior harness failed \(failures.count) of \(passed + failures.count) checks.\n", stderr)
    for failure in failures {
        fputs("- \(failure)\n", stderr)
    }
    exit(EXIT_FAILURE)
}
