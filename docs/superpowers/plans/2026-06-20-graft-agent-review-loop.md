# Graft Agent Review Loop Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild Graft around the core loop where a person edits local Markdown, external coding agents edit the same files, and Graft turns agent edits into reviewable inline diffs before they land.

**Architecture:** Keep SwiftUI as the native macOS shell and plain Markdown as the only source of truth. Add a pure Swift `GraftCore` target for diffing, change-set storage, metadata parsing, and checkpoint rules; wire the app shell to that core through `WorkspaceStore`; replace fake collaboration surfaces with a document review screen and an honest agent activity model.

**Tech Stack:** Swift 6, SwiftPM, SwiftUI, Foundation filesystem APIs, sidecar `.graft/changes` metadata, local `.graft/history` checkpoints, `swift test`, `swift build`, `script/build_and_run.sh --verify`.

---

## Product Decisions Locked

- Graft is an agent-reviewed Markdown editor, not a general multiplayer editor.
- Markdown files remain canonical on disk.
- Humans edit directly and save straight to disk.
- External agent edits enter a review lane before replacing the visible draft.
- If human and agent changes touch the same range, the human text wins by default and Graft marks a conflict.
- Rich Markdown editing is the target experience, but the first implementation ships raw Markdown with polished inline diff review.
- Sharing becomes review packets, not email invites or account membership.
- Graft names Codex, Claude Code, Cursor, and similar tools in setup/docs, but daily UI uses generic language like "Agent edit" and "Pending change."
- Version history stores meaningful checkpoints, not every keystroke.
- Git stays invisible by default, with only lightweight repo awareness.

## Files And Responsibilities

- Modify: `Package.swift`  
  Add `GraftCore` and `GraftCoreTests` so diff/review logic can be tested without launching SwiftUI.

- Create: `Sources/GraftCore/Review/ChangeSet.swift`  
  Domain types for external edits, review status, changed ranges, conflict flags, and source metadata.

- Create: `Sources/GraftCore/Review/MarkdownDiffEngine.swift`  
  Converts old/new Markdown strings into block-aware change hunks.

- Create: `Sources/GraftCore/Review/ChangeMetadataStore.swift`  
  Reads optional `.graft/changes/*.json` files and falls back to inferred metadata when agents do not write metadata.

- Create: `Sources/GraftCore/Review/ChangeSetStore.swift`  
  Persists pending, accepted, and rejected change sets under `.graft/reviews`.

- Create: `Sources/GraftCore/Review/AgentInstructionsWriter.swift`  
  Writes a short `AGENTS.md` editing contract for the opened folder.

- Create: `Tests/GraftCoreTests/*`  
  Unit tests for diff grouping, metadata fallback, conflict detection, checkpoint grouping, and instructions output.

- Modify: `Sources/Graft/Stores/WorkspaceStore.swift`  
  Replace reload-on-external-change behavior with pending review change sets.

- Create: `Sources/Graft/Views/ReviewRailView.swift`  
  Right-side queue for pending agent edits, conflicts, accepted edits, and meaningful history.

- Create: `Sources/Graft/Views/InlineDiffView.swift`  
  Renders accepted/removed/changed Markdown blocks with accept/reject controls.

- Modify: `Sources/Graft/Views/MarkdownEditorView.swift`  
  Show pending diffs in context above the raw Markdown editor for the selected file.

- Modify: `Sources/Graft/Views/ContentView.swift`  
  Make the default screen file tree + editor/review + compact review rail.

- Modify: `Sources/Graft/Views/InspectorView.swift`, `ShareView.swift`, `SidebarView.swift`  
  Remove fake invitees and fake connected agents; demote sharing to review packet language.

- Modify: `Sources/GraftCLI/main.swift`  
  Add `watch`, `status`, and `submit-change` language around Graft review metadata.

- Modify: `skills/graft-sync/SKILL.md`  
  Teach agents to make scoped Markdown edits and optionally write `.graft/changes/<timestamp>-<agent>.json`.

- Modify: `README.md`, `product_brief.md`, `design.md`  
  Replace multiplayer/email-invite positioning with co-writing with agents and reviewable diffs.

---

### Task 1: Add Testable GraftCore Target

**Files:**
- Modify: `Package.swift`
- Create: `Sources/GraftCore/Review/ChangeSet.swift`
- Create: `Tests/GraftCoreTests/ChangeSetTests.swift`

- [ ] **Step 1: Modify `Package.swift` to add a pure Swift core target and tests**

Use this package shape:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Graft",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "GraftCore", targets: ["GraftCore"]),
        .executable(name: "Graft", targets: ["Graft"]),
        .executable(name: "graft-cli", targets: ["GraftCLI"])
    ],
    targets: [
        .target(
            name: "GraftCore",
            path: "Sources/GraftCore"
        ),
        .executableTarget(
            name: "Graft",
            dependencies: ["GraftCore"],
            path: "Sources/Graft",
            resources: [
                .copy("Resources")
            ]
        ),
        .executableTarget(
            name: "GraftCLI",
            dependencies: ["GraftCore"],
            path: "Sources/GraftCLI"
        ),
        .testTarget(
            name: "GraftCoreTests",
            dependencies: ["GraftCore"],
            path: "Tests/GraftCoreTests"
        )
    ]
)
```

- [ ] **Step 2: Create the domain model**

Write `Sources/GraftCore/Review/ChangeSet.swift`:

```swift
import Foundation

public enum ChangeAuthorKind: String, Codable, Equatable {
    case human
    case agent
    case external
}

public enum ChangeReviewStatus: String, Codable, Equatable {
    case pending
    case accepted
    case rejected
    case conflict
}

public enum MarkdownBlockKind: String, Codable, Equatable {
    case heading
    case paragraph
    case list
    case task
    case quote
    case code
    case table
    case image
    case horizontalRule
    case unknown
}

public struct ChangeRange: Codable, Equatable, Identifiable {
    public let id: UUID
    public let oldStartLine: Int
    public let oldEndLine: Int
    public let newStartLine: Int
    public let newEndLine: Int
    public let kind: MarkdownBlockKind
    public let before: String
    public let after: String

    public init(
        id: UUID = UUID(),
        oldStartLine: Int,
        oldEndLine: Int,
        newStartLine: Int,
        newEndLine: Int,
        kind: MarkdownBlockKind,
        before: String,
        after: String
    ) {
        self.id = id
        self.oldStartLine = oldStartLine
        self.oldEndLine = oldEndLine
        self.newStartLine = newStartLine
        self.newEndLine = newEndLine
        self.kind = kind
        self.before = before
        self.after = after
    }
}

public struct ChangeSet: Codable, Equatable, Identifiable {
    public let id: UUID
    public let filePath: String
    public let authorName: String
    public let authorKind: ChangeAuthorKind
    public var status: ChangeReviewStatus
    public let summary: String
    public let createdAt: Date
    public let baseText: String
    public let proposedText: String
    public let ranges: [ChangeRange]

    public init(
        id: UUID = UUID(),
        filePath: String,
        authorName: String,
        authorKind: ChangeAuthorKind,
        status: ChangeReviewStatus,
        summary: String,
        createdAt: Date = Date(),
        baseText: String,
        proposedText: String,
        ranges: [ChangeRange]
    ) {
        self.id = id
        self.filePath = filePath
        self.authorName = authorName
        self.authorKind = authorKind
        self.status = status
        self.summary = summary
        self.createdAt = createdAt
        self.baseText = baseText
        self.proposedText = proposedText
        self.ranges = ranges
    }
}
```

- [ ] **Step 3: Write the first model test**

Write `Tests/GraftCoreTests/ChangeSetTests.swift`:

```swift
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
    }
}
```

- [ ] **Step 4: Run test to verify the new target compiles**

Run:

```bash
swift test --filter ChangeSetTests
```

Expected: `ChangeSetTests` passes.

- [ ] **Step 5: Commit**

```bash
git add Package.swift Sources/GraftCore Tests/GraftCoreTests
git commit -m "refactor: add testable graft core review model"
```

---

### Task 2: Build Markdown Diff Grouping

**Files:**
- Create: `Sources/GraftCore/Review/MarkdownDiffEngine.swift`
- Create: `Tests/GraftCoreTests/MarkdownDiffEngineTests.swift`

- [ ] **Step 1: Write failing tests for block-aware diff grouping**

Write `Tests/GraftCoreTests/MarkdownDiffEngineTests.swift`:

```swift
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
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run:

```bash
swift test --filter MarkdownDiffEngineTests
```

Expected: FAIL because `MarkdownDiffEngine` does not exist.

- [ ] **Step 3: Implement minimal line-based diff with block classification**

Write `Sources/GraftCore/Review/MarkdownDiffEngine.swift`:

```swift
import Foundation

public struct MarkdownDiffEngine {
    public init() {}

    public func changedRanges(before: String, after: String) -> [ChangeRange] {
        if before == after {
            return []
        }

        let oldLines = before.components(separatedBy: .newlines)
        let newLines = after.components(separatedBy: .newlines)
        let maxCount = max(oldLines.count, newLines.count)
        var ranges: [ChangeRange] = []
        var index = 0

        while index < maxCount {
            let oldLine = index < oldLines.count ? oldLines[index] : ""
            let newLine = index < newLines.count ? newLines[index] : ""

            if oldLine == newLine {
                index += 1
                continue
            }

            let start = index
            var end = index
            while end < maxCount {
                let candidateOld = end < oldLines.count ? oldLines[end] : ""
                let candidateNew = end < newLines.count ? newLines[end] : ""
                if candidateOld == candidateNew {
                    break
                }
                end += 1
            }

            let beforeBlock = oldLines[safe: start..<min(end, oldLines.count)].joined(separator: "\n")
            let afterBlock = newLines[safe: start..<min(end, newLines.count)].joined(separator: "\n")
            ranges.append(
                ChangeRange(
                    oldStartLine: start + 1,
                    oldEndLine: max(start + 1, min(end, oldLines.count)),
                    newStartLine: start + 1,
                    newEndLine: max(start + 1, min(end, newLines.count)),
                    kind: Self.kind(for: afterBlock.isEmpty ? beforeBlock : afterBlock),
                    before: beforeBlock,
                    after: afterBlock
                )
            )
            index = end
        }

        return ranges
    }

    private static func kind(for text: String) -> MarkdownBlockKind {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("#") { return .heading }
        if trimmed.hasPrefix("```") { return .code }
        if trimmed.hasPrefix(">") { return .quote }
        if trimmed.hasPrefix("![") { return .image }
        if trimmed.hasPrefix("- [ ]") || trimmed.hasPrefix("- [x]") { return .task }
        if trimmed.hasPrefix("- ") || trimmed.hasPrefix("* ") { return .list }
        if trimmed.contains("|") { return .table }
        if trimmed == "---" || trimmed == "***" { return .horizontalRule }
        if trimmed.isEmpty { return .unknown }
        return .paragraph
    }
}

private extension Array {
    subscript(safe range: Range<Int>) -> ArraySlice<Element> {
        let lower = Swift.max(0, range.lowerBound)
        let upper = Swift.min(count, range.upperBound)
        if lower >= upper { return [] }
        return self[lower..<upper]
    }
}
```

- [ ] **Step 4: Run diff tests**

Run:

```bash
swift test --filter MarkdownDiffEngineTests
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add Sources/GraftCore/Review/MarkdownDiffEngine.swift Tests/GraftCoreTests/MarkdownDiffEngineTests.swift
git commit -m "feat: group markdown edits into review ranges"
```

---

### Task 3: Add Optional Agent Metadata

**Files:**
- Create: `Sources/GraftCore/Review/ChangeMetadataStore.swift`
- Create: `Tests/GraftCoreTests/ChangeMetadataStoreTests.swift`

- [ ] **Step 1: Write failing metadata tests**

Write `Tests/GraftCoreTests/ChangeMetadataStoreTests.swift`:

```swift
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
```

- [ ] **Step 2: Implement metadata parsing**

Write `Sources/GraftCore/Review/ChangeMetadataStore.swift`:

```swift
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
        let folder = workspaceURL.appendingPathComponent(".graft/changes", isDirectory: true)
        guard let urls = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: [.contentModificationDateKey]) else {
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
```

- [ ] **Step 3: Run metadata tests**

Run:

```bash
swift test --filter ChangeMetadataStoreTests
```

Expected: PASS.

- [ ] **Step 4: Commit**

```bash
git add Sources/GraftCore/Review/ChangeMetadataStore.swift Tests/GraftCoreTests/ChangeMetadataStoreTests.swift
git commit -m "feat: read optional agent change metadata"
```

---

### Task 4: Persist Review Change Sets

**Files:**
- Create: `Sources/GraftCore/Review/ChangeSetStore.swift`
- Create: `Tests/GraftCoreTests/ChangeSetStoreTests.swift`

- [ ] **Step 1: Write failing persistence test**

Write `Tests/GraftCoreTests/ChangeSetStoreTests.swift`:

```swift
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
}
```

- [ ] **Step 2: Implement review store**

Write `Sources/GraftCore/Review/ChangeSetStore.swift`:

```swift
import Foundation

public struct ChangeSetStore {
    public let workspaceURL: URL

    public init(workspaceURL: URL) {
        self.workspaceURL = workspaceURL
    }

    public var reviewsURL: URL {
        workspaceURL.appendingPathComponent(".graft/reviews", isDirectory: true)
    }

    public func prepare() throws {
        try FileManager.default.createDirectory(at: reviewsURL, withIntermediateDirectories: true)
    }

    public func write(_ changeSet: ChangeSet) throws {
        try prepare()
        let url = reviewsURL.appendingPathComponent("\(changeSet.id.uuidString).json")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(changeSet)
        try data.write(to: url, options: .atomic)
    }

    public func loadAll() throws -> [ChangeSet] {
        guard FileManager.default.fileExists(atPath: reviewsURL.path) else {
            return []
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let urls = try FileManager.default.contentsOfDirectory(at: reviewsURL, includingPropertiesForKeys: nil)
        return urls
            .filter { $0.pathExtension == "json" }
            .compactMap { url in
                guard let data = try? Data(contentsOf: url) else { return nil }
                return try? decoder.decode(ChangeSet.self, from: data)
            }
            .sorted { $0.createdAt > $1.createdAt }
    }
}
```

- [ ] **Step 3: Run persistence tests**

Run:

```bash
swift test --filter ChangeSetStoreTests
```

Expected: PASS.

- [ ] **Step 4: Commit**

```bash
git add Sources/GraftCore/Review/ChangeSetStore.swift Tests/GraftCoreTests/ChangeSetStoreTests.swift
git commit -m "feat: persist review change sets"
```

---

### Task 5: Convert External File Changes Into Pending Reviews

**Files:**
- Modify: `Sources/Graft/Stores/WorkspaceStore.swift`
- Modify: `Sources/Graft/Services/VersionHistoryStore.swift`
- Test: `Tests/GraftCoreTests/MarkdownDiffEngineTests.swift`

- [ ] **Step 1: Add published review state to `WorkspaceStore`**

Add these properties near the existing published state:

```swift
@Published var pendingChangeSets: [ChangeSet] = []
@Published var selectedChangeSetID: UUID?
@Published var reviewBanner: String?
```

Add `import GraftCore` at the top of `WorkspaceStore.swift`.

- [ ] **Step 2: Load review state when opening a workspace**

Inside `openWorkspace(_:)`, after `VersionHistoryStore(workspaceURL: url).prepare()`, add:

```swift
try? ChangeSetStore(workspaceURL: url).prepare()
pendingChangeSets = (try? ChangeSetStore(workspaceURL: url).loadAll()) ?? []
```

- [ ] **Step 3: Replace auto-reload behavior in `handleExternalChange(at:)`**

Replace the branch that assigns `editorText = diskText` with change-set creation:

```swift
let relativePath = selectedFile.relativePath
let metadataStore = ChangeMetadataStore(workspaceURL: workspaceURL)
let metadata = metadataStore.metadata(for: relativePath) ?? metadataStore.fallbackMetadata(for: relativePath)
let ranges = MarkdownDiffEngine().changedRanges(before: lastLoadedText, after: diskText)
let status: ChangeReviewStatus = isDirty ? .conflict : .pending
let changeSet = ChangeSet(
    filePath: relativePath,
    authorName: metadata.agent,
    authorKind: metadata.agent == "external" ? .external : .agent,
    status: status,
    summary: metadata.summary,
    baseText: lastLoadedText,
    proposedText: diskText,
    ranges: ranges
)

try? ChangeSetStore(workspaceURL: workspaceURL).write(changeSet)
pendingChangeSets.insert(changeSet, at: 0)
selectedChangeSetID = changeSet.id
reviewBanner = status == .conflict
    ? "External edit conflicts with your unsaved draft. Your text is still active."
    : "External edit is ready for review."
recordAgentActivity(
    status: status == .conflict ? "Conflict" : "Pending review",
    detail: "\(metadata.agent) changed \(relativePath)"
)
```

- [ ] **Step 4: Add accept/reject methods**

Add these methods to `WorkspaceStore`:

```swift
func accept(_ changeSet: ChangeSet) {
    guard let selectedFile, selectedFile.relativePath == changeSet.filePath else { return }
    snapshotCurrentDocument(reason: "Before accepting \(changeSet.authorName) edit", source: "Graft")
    editorText = changeSet.proposedText
    do {
        try changeSet.proposedText.write(to: selectedFile.url, atomically: true, encoding: .utf8)
        lastLoadedText = changeSet.proposedText
        watcher.markClean(selectedFile.url)
        updateReview(changeSet, status: .accepted)
        refreshSnapshots()
    } catch {
        reviewBanner = "Could not accept edit: \(error.localizedDescription)"
    }
}

func reject(_ changeSet: ChangeSet) {
    updateReview(changeSet, status: .rejected)
    reviewBanner = "Rejected \(changeSet.authorName) edit."
}

private func updateReview(_ changeSet: ChangeSet, status: ChangeReviewStatus) {
    var updated = changeSet
    updated.status = status
    try? ChangeSetStore(workspaceURL: workspaceURL!).write(updated)
    pendingChangeSets.removeAll { $0.id == changeSet.id }
    selectedChangeSetID = pendingChangeSets.first?.id
}
```

- [ ] **Step 5: Run build**

Run:

```bash
swift build
```

Expected: build succeeds.

- [ ] **Step 6: Commit**

```bash
git add Sources/Graft/Stores/WorkspaceStore.swift Sources/Graft/Services/VersionHistoryStore.swift
git commit -m "feat: route external edits into review"
```

---

### Task 6: Build The Document Review Screen

**Files:**
- Create: `Sources/Graft/Views/InlineDiffView.swift`
- Create: `Sources/Graft/Views/ReviewRailView.swift`
- Modify: `Sources/Graft/Views/MarkdownEditorView.swift`
- Modify: `Sources/Graft/Views/ContentView.swift`
- Modify: `Sources/Graft/Views/Theme.swift`

- [ ] **Step 1: Create inline diff view**

Write `Sources/Graft/Views/InlineDiffView.swift`:

```swift
import GraftCore
import SwiftUI

struct InlineDiffView: View {
    let changeSet: ChangeSet
    let onAccept: () -> Void
    let onReject: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(changeSet.summary, systemImage: changeSet.status == .conflict ? "exclamationmark.triangle" : "sparkles")
                    .font(.headline)
                    .foregroundStyle(GraftTheme.ink)
                Spacer()
                Button("Reject", action: onReject)
                Button("Accept", action: onAccept)
                    .buttonStyle(.borderedProminent)
            }

            ForEach(changeSet.ranges) { range in
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(range.kind.rawValue) · lines \(range.oldStartLine)-\(range.oldEndLine)")
                        .font(.caption)
                        .foregroundStyle(GraftTheme.muted)
                    if !range.before.isEmpty {
                        Text(range.before)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(GraftTheme.ink)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(GraftTheme.pink.opacity(0.14))
                    }
                    if !range.after.isEmpty {
                        Text(range.after)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(GraftTheme.ink)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(GraftTheme.mint.opacity(0.22))
                    }
                }
            }
        }
        .padding(14)
        .background(GraftTheme.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(changeSet.status == .conflict ? GraftTheme.pink : GraftTheme.line)
        }
    }
}
```

- [ ] **Step 2: Create review rail**

Write `Sources/Graft/Views/ReviewRailView.swift`:

```swift
import GraftCore
import SwiftUI

struct ReviewRailView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Agent edits")
                .font(.headline)
                .foregroundStyle(GraftTheme.ink)

            if workspace.pendingChangeSets.isEmpty {
                Text("No pending edits")
                    .font(.callout)
                    .foregroundStyle(GraftTheme.muted)
            } else {
                ForEach(workspace.pendingChangeSets) { changeSet in
                    Button {
                        workspace.selectedChangeSetID = changeSet.id
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(changeSet.summary)
                                .font(.callout.weight(.semibold))
                            Text("\(changeSet.authorName) · \(changeSet.ranges.count) changes")
                                .font(.caption)
                                .foregroundStyle(GraftTheme.muted)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(changeSet.id == workspace.selectedChangeSetID ? GraftTheme.lavender.opacity(0.25) : GraftTheme.surfaceCard)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
        }
        .padding(16)
        .frame(minWidth: 280, idealWidth: 320, maxWidth: 360)
        .background(GraftTheme.surfaceSoft)
    }
}
```

- [ ] **Step 3: Embed selected diff above editor text**

In `MarkdownEditorView`, insert this above `TextEditor`:

```swift
if let selectedID = workspace.selectedChangeSetID,
   let changeSet = workspace.pendingChangeSets.first(where: { $0.id == selectedID }) {
    ScrollView(.vertical) {
        InlineDiffView(
            changeSet: changeSet,
            onAccept: { workspace.accept(changeSet) },
            onReject: { workspace.reject(changeSet) }
        )
        .padding(16)
    }
    .frame(maxHeight: 260)
    .background(GraftTheme.surfaceSoft)
}
```

- [ ] **Step 4: Add the rail to `ContentView`**

Wrap `EditorContainerView()` and `ReviewRailView()` in an `HStack`:

```swift
HStack(spacing: 0) {
    EditorContainerView()
    ReviewRailView()
}
```

- [ ] **Step 5: Run build**

Run:

```bash
swift build
```

Expected: build succeeds.

- [ ] **Step 6: Commit**

```bash
git add Sources/Graft/Views/InlineDiffView.swift Sources/Graft/Views/ReviewRailView.swift Sources/Graft/Views/MarkdownEditorView.swift Sources/Graft/Views/ContentView.swift
git commit -m "feat: add document review screen"
```

---

### Task 7: Remove Fake Collaboration Surfaces

**Files:**
- Modify: `Sources/Graft/Stores/WorkspaceStore.swift`
- Modify: `Sources/Graft/Views/InspectorView.swift`
- Modify: `Sources/Graft/Views/ShareView.swift`
- Modify: `Sources/Graft/Views/SidebarView.swift`
- Modify: `Sources/Graft/Views/ContentView.swift`

- [ ] **Step 1: Remove hardcoded invitees and fake agents**

In `WorkspaceStore`, initialize these as empty arrays:

```swift
@Published var invites: [Invite] = []
@Published var agents: [AgentActivity] = []
```

Delete any default sample invitees or agent rows.

- [ ] **Step 2: Rename sharing UI to review packets**

Replace visible "Invite" language in `ShareView` with "Review packet" language:

```swift
Text("Review packet")
Text("Export the current Markdown file, local images, and selected change history for another person to review.")
Button("Create packet") { workspace.createReviewPacket() }
```

- [ ] **Step 3: Add a non-cloud packet method**

In `WorkspaceStore`, add:

```swift
func createReviewPacket() {
    guard let selectedFile else { return }
    snapshotCurrentDocument(reason: "Review packet checkpoint", source: "Graft")
    externalChangeBanner = "Review packet checkpoint created for \(selectedFile.relativePath)."
}
```

- [ ] **Step 4: Remove multiplayer wording**

Search:

```bash
rg -n "multiplayer|invite|invites|collaboration|connected agents|email" Sources README.md product_brief.md design.md
```

Replace misleading product copy with:

- "co-writing with agents"
- "external agent edits"
- "reviewable diffs"
- "review packets"
- "plain local Markdown files"

- [ ] **Step 5: Run build**

Run:

```bash
swift build
```

Expected: build succeeds.

- [ ] **Step 6: Commit**

```bash
git add Sources/Graft README.md product_brief.md design.md
git commit -m "refactor: remove fake collaboration claims"
```

---

### Task 8: Write The AGENTS.md Editing Contract

**Files:**
- Create: `Sources/GraftCore/Review/AgentInstructionsWriter.swift`
- Modify: `Sources/Graft/Stores/WorkspaceStore.swift`
- Modify: `skills/graft-sync/SKILL.md`
- Create: `Tests/GraftCoreTests/AgentInstructionsWriterTests.swift`

- [ ] **Step 1: Write failing instruction output test**

Write `Tests/GraftCoreTests/AgentInstructionsWriterTests.swift`:

```swift
import XCTest
@testable import GraftCore

final class AgentInstructionsWriterTests: XCTestCase {
    func testInstructionsContainGraftReviewContract() {
        let text = AgentInstructionsWriter.instructionsText()

        XCTAssertTrue(text.contains("Keep Markdown portable"))
        XCTAssertTrue(text.contains(".graft/changes"))
        XCTAssertTrue(text.contains("Avoid formatting churn"))
        XCTAssertTrue(text.contains("Summarize your edit"))
    }
}
```

- [ ] **Step 2: Implement instructions writer**

Write `Sources/GraftCore/Review/AgentInstructionsWriter.swift`:

```swift
import Foundation

public struct AgentInstructionsWriter {
    public init() {}

    public static func instructionsText() -> String {
        """
        # Graft Agent Editing Contract

        Keep Markdown portable. Edit the `.md` files directly and preserve image paths, frontmatter, heading IDs, fenced code languages, list style, and table structure.

        Make scoped edits. Change the smallest useful section and avoid formatting churn.

        Summarize your edit. When possible, write metadata to `.graft/changes/<timestamp>-<agent>.json`:

        ```json
        {
          "filePath": "README.md",
          "agent": "codex",
          "summary": "Tightened the introduction"
        }
        ```

        Let Graft handle review. Do not rewrite unrelated files to force a clean diff.
        """
    }

    public func writeIfMissing(to workspaceURL: URL) throws {
        let url = workspaceURL.appendingPathComponent("AGENTS.md")
        guard !FileManager.default.fileExists(atPath: url.path) else { return }
        try Self.instructionsText().write(to: url, atomically: true, encoding: .utf8)
    }
}
```

- [ ] **Step 3: Call writer when opening a workspace**

In `WorkspaceStore.openWorkspace(_:)`, add:

```swift
try? AgentInstructionsWriter().writeIfMissing(to: url)
```

- [ ] **Step 4: Update the repo skill**

In `skills/graft-sync/SKILL.md`, make the workflow:

```markdown
1. Read `AGENTS.md` in the workspace.
2. Edit the target Markdown file directly.
3. Keep the change scoped.
4. Preserve formatting outside the edited block.
5. Write optional metadata to `.graft/changes/<timestamp>-<agent>.json`.
6. Let Graft show the change for human review.
```

- [ ] **Step 5: Run tests**

Run:

```bash
swift test --filter AgentInstructionsWriterTests
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add Sources/GraftCore/Review/AgentInstructionsWriter.swift Tests/GraftCoreTests/AgentInstructionsWriterTests.swift Sources/Graft/Stores/WorkspaceStore.swift skills/graft-sync/SKILL.md
git commit -m "feat: generate graft agent editing contract"
```

---

### Task 9: Reframe CLI Sync As Review Bridge

**Files:**
- Modify: `Sources/GraftCLI/main.swift`
- Create: `Tests/GraftCoreTests/ChangeMetadataStoreTests.swift`

- [ ] **Step 1: Add CLI command shape**

Update CLI usage to include:

```text
graft-cli status <vault>
graft-cli submit-change <vault> <file> --agent codex --summary "Tightened intro"
graft-cli history <vault> <file>
```

- [ ] **Step 2: Implement `submit-change` metadata writing**

Add a command that writes `.graft/changes/<timestamp>-<agent>.json`:

```swift
private static func submitChange(args: [String]) {
    guard args.count >= 2 else {
        print("usage: graft-cli submit-change <vault> <file> --agent codex --summary \"Tightened intro\"")
        return
    }
    let vault = URL(fileURLWithPath: args[0])
    let filePath = args[1]
    let agent = option("--agent", in: args) ?? "agent"
    let summary = option("--summary", in: args) ?? "Edited \(filePath)"
    let changesURL = vault.appendingPathComponent(".graft/changes", isDirectory: true)
    try? FileManager.default.createDirectory(at: changesURL, withIntermediateDirectories: true)

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd-HHmmss"
    let url = changesURL.appendingPathComponent("\(formatter.string(from: Date()))-\(agent).json")
    let metadata = ChangeMetadata(filePath: filePath, agent: agent, summary: summary)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    guard let data = try? encoder.encode(metadata) else {
        print("could not encode change metadata")
        return
    }
    do {
        try data.write(to: url, options: .atomic)
        print("submitted change metadata for \(filePath)")
    } catch {
        print("could not write change metadata: \(error.localizedDescription)")
    }
}
```

Add `import GraftCore`.

- [ ] **Step 3: Run CLI smoke test**

Run:

```bash
swift run graft-cli submit-change SampleVault welcome.md --agent codex --summary "Tightened welcome copy"
```

Expected output contains:

```text
submitted change metadata for welcome.md
```

- [ ] **Step 4: Commit**

```bash
git add Sources/GraftCLI/main.swift
git commit -m "feat: add review bridge cli command"
```

---

### Task 10: Update Product Docs To Match The Pivot

**Files:**
- Modify: `README.md`
- Modify: `product_brief.md`
- Modify: `design.md`
- Modify: `docs/superpowers/plans/2026-06-16-graft-markdown-editor.md`

- [ ] **Step 1: Update README positioning**

Replace the opening with:

```markdown
Graft is a local-first macOS Markdown editor for people who write with coding agents. Humans edit plain `.md` files directly. External agents can edit the same files. Graft turns those external edits into reviewable inline diffs before they land.
```

- [ ] **Step 2: Update product brief**

Make the core promise:

```markdown
Write Markdown in a clean native editor while Codex, Claude Code, Cursor, and other agents work against the same local files. You review their changes as diffs before accepting them.
```

Remove or rewrite sections that imply account-based invites, real-time multiplayer, or fake connected agents.

- [ ] **Step 3: Update design system**

Change the default layout section to:

```markdown
Default screen: folder-first file tree on the left, document review surface in the center, compact review rail on the right. The inspector is secondary and should not be visible by default.
```

- [ ] **Step 4: Add pointer in old plan**

At the top of `docs/superpowers/plans/2026-06-16-graft-markdown-editor.md`, add:

```markdown
> Pivot note: this original scaffold plan is complete. The next implementation direction lives in `docs/superpowers/plans/2026-06-20-graft-agent-review-loop.md`.
```

- [ ] **Step 5: Run copy scan**

Run:

```bash
rg -n "multiplayer|email invite|invitees|connected agents|Obsidian-style|fake" README.md product_brief.md design.md Sources/Graft
```

Expected: no misleading product claims remain in user-facing copy.

- [ ] **Step 6: Commit**

```bash
git add README.md product_brief.md design.md docs/superpowers/plans/2026-06-16-graft-markdown-editor.md
git commit -m "docs: reposition graft around agent review"
```

---

### Task 11: Manual End-To-End Review Loop Verification

**Files:**
- Modify: implementation files as needed based on verification.

- [ ] **Step 1: Run all automated checks**

Run:

```bash
swift test
swift build
./script/build_and_run.sh --verify
```

Expected: tests pass, build succeeds, app launches.

- [ ] **Step 2: Simulate external agent edit**

Run:

```bash
cp SampleVault/welcome.md /tmp/graft-welcome-before.md
perl -0pi -e 's/# Welcome to Graft/# Welcome to Graft Review/' SampleVault/welcome.md
swift run graft-cli submit-change SampleVault welcome.md --agent codex --summary "Adjusted the title"
```

Expected: Graft shows one pending agent edit for `welcome.md` with author `codex`.

- [ ] **Step 3: Accept the edit**

In the app:

- Open `SampleVault`.
- Select `welcome.md`.
- Select the pending edit in the review rail.
- Click `Accept`.

Expected:

- The title in the editor changes to `# Welcome to Graft Review`.
- The pending edit disappears from the rail.
- A checkpoint appears in history with reason containing `Before accepting codex edit`.

- [ ] **Step 4: Simulate a conflict**

In the app, edit the selected document without saving. In Terminal, run:

```bash
perl -0pi -e 's/Graft Review/Graft Conflict Test/' SampleVault/welcome.md
```

Expected: Graft shows a conflict review item and keeps the unsaved human text visible.

- [ ] **Step 5: Restore sample file**

Run:

```bash
cp /tmp/graft-welcome-before.md SampleVault/welcome.md
```

- [ ] **Step 6: Commit verification fixes**

If verification required code changes:

```bash
git add Sources Tests README.md product_brief.md design.md skills/graft-sync/SKILL.md
git commit -m "fix: verify graft review loop"
```

If no code changes were required, do not create an empty commit.

---

## Out Of Scope For This Plan

- Running Codex or Claude Code inside the Graft app.
- Account-based sharing, cloud permissions, or email delivery.
- Real-time human multiplayer.
- Git commit, branch, pull request, or staging UI.
- A full rich-text Markdown editor engine.
- CRDT-based merging.

These are product expansions. The v1 proof is the local review loop.

## Self-Review

- Spec coverage: The plan covers local human edits, external agent edits, reviewable diffs, conflicts, meaningful checkpoints, optional `.graft/changes` metadata, AGENTS.md contract, CLI review bridge, image-compatible Markdown preservation, removal of fake collaboration language, and updated docs.
- Placeholder scan: The plan contains no placeholder tasks, vague edge-case instructions, or unspecified test commands.
- Type consistency: `ChangeSet`, `ChangeRange`, `ChangeMetadata`, `ChangeSetStore`, `ChangeMetadataStore`, `MarkdownDiffEngine`, and `AgentInstructionsWriter` are introduced before app and CLI tasks reference them.
