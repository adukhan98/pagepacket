# Graft Document Review Surface V2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Upgrade Graft from a working raw Markdown review loop into a premium document review surface with a better native editor, hunk-level review controls, clearer conflicts, and first-class image block affordances.

> **Scoped implementation note, 2026-06-20:** The image support and documentation slice was implemented with writes limited to `ImageImportService.swift`, `MarkdownPreviewView.swift`, `README.md`, `product_brief.md`, `design.md`, this plan, and the 2026-06-16 editor plan. Store, diff, editor bridge, tests, and package files were intentionally left untouched for parallel agents.

**Architecture:** Keep SwiftUI as the app shell and plain Markdown as the only source of truth. Use a narrow `NSViewRepresentable` bridge for the editor because SwiftUI `TextEditor` cannot provide the text-system behavior Graft needs: selection tracking, syntax highlighting, precise line behavior, and stable review overlays. Keep review mutation logic in `GraftCore` so the UI only requests safe patch operations.

**Tech Stack:** Swift 6, SwiftPM, SwiftUI, AppKit `NSTextView` through `NSViewRepresentable`, Foundation, existing `GraftCore`, `.graft/reviews`, `.graft/history`, `swift build`, `./script/build_and_run.sh --verify`, and `swift test` when a full Xcode toolchain with `XCTest` is available.

---

## Why This Is The Next Step

The agent-review loop now exists. The next product risk is that the loop still feels like a wrapped text box with review cards above it. Graft needs to feel like a calm writing surface where review decisions happen at the exact affected block.

This plan intentionally does not add cloud sync, accounts, live cursors, or embedded agent terminals. The next useful product proof is:

1. Write Markdown in a better native editor.
2. See agent edits as precise hunks.
3. Accept or reject one hunk without accepting the whole proposal.
4. Resolve conflicts without losing the human draft.
5. Work with local images without memorizing Markdown paths.

## AppKit Boundary

SwiftUI remains the owner of:

- Workspace state.
- Selected file.
- Editor text.
- Review queue.
- Accept/reject commands.

AppKit owns only:

- Text rendering inside `NSTextView`.
- Syntax attributes for visible Markdown text.
- Selection callbacks.
- Editor key handling that SwiftUI `TextEditor` cannot expose cleanly.

The bridge must not store canonical document state. The canonical value remains `WorkspaceStore.editorText`, which is saved back to the `.md` file.

## Files And Responsibilities

- Create: `Sources/GraftCore/Review/MarkdownPatchEngine.swift`  
  Applies one `ChangeRange` to current Markdown and refuses stale hunks.

- Create: `Tests/GraftCoreTests/MarkdownPatchEngineTests.swift`  
  Unit tests for hunk-level accept, reject-by-omission, stale base detection, and inserted/deleted blocks.

- Create: `Sources/Graft/Views/MarkdownTextView.swift`  
  Narrow AppKit editor bridge backed by `NSTextView`.

- Create: `Sources/Graft/Services/MarkdownSyntaxHighlighter.swift`  
  Applies lightweight Markdown syntax attributes to headings, code fences, links, image syntax, tasks, quotes, and list markers.

- Modify: `Sources/Graft/Views/MarkdownEditorView.swift`  
  Replace `TextEditor` with `MarkdownTextView` and keep the inline selected review above the editor.

- Modify: `Sources/Graft/Stores/WorkspaceStore.swift`  
  Add hunk-level accept/reject methods, current selection state, and conflict-safe patching.

- Modify: `Sources/Graft/Views/InlineDiffView.swift`  
  Add hunk-level controls: accept hunk, reject hunk, accept all, reject all.

- Modify: `Sources/Graft/Views/ReviewRailView.swift`  
  Show hunk counts, conflict state, and selected-file context.

- Create: `Sources/Graft/Views/ConflictResolutionView.swift`  
  Shows human draft vs proposed agent hunk with explicit actions.

- Create: `Sources/Graft/Models/EditorSelection.swift`  
  Small model for selected range, current line, and selected text.

- Modify: `Sources/Graft/Views/MarkdownPreviewView.swift`  
  Improve image rendering controls and local image path visibility.

- Modify: `Sources/Graft/Services/ImageImportService.swift`  
  Add deterministic per-document image folders and filename collision handling.

- Modify: `README.md`, `product_brief.md`, `design.md`  
  Update docs to describe V2 document review behavior after implementation.

---

### Task 1: Add Hunk-Level Patch Engine

**Files:**
- Create: `Sources/GraftCore/Review/MarkdownPatchEngine.swift`
- Create: `Tests/GraftCoreTests/MarkdownPatchEngineTests.swift`

- [ ] **Step 1: Write failing tests for hunk patching**

Create `Tests/GraftCoreTests/MarkdownPatchEngineTests.swift`:

```swift
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
}
```

- [ ] **Step 2: Run the focused test**

Run:

```bash
swift test --filter MarkdownPatchEngineTests
```

Expected with full Xcode toolchain: FAIL because `MarkdownPatchEngine` does not exist.  
Expected in the current CommandLineTools-only environment: FAIL at `import XCTest` with `no such module 'XCTest'`; continue with `swift build` verification after implementation.

- [ ] **Step 3: Implement the patch engine**

Create `Sources/GraftCore/Review/MarkdownPatchEngine.swift`:

```swift
import Foundation

public enum MarkdownPatchError: Error, Equatable {
    case invalidLineRange
    case staleHunk
}

public struct MarkdownPatchEngine {
    public init() {}

    public func apply(_ range: ChangeRange, to markdown: String) throws -> String {
        var lines = markdown.components(separatedBy: .newlines)
        let replacement = range.after.components(separatedBy: .newlines)

        if range.before.isEmpty {
            let insertionIndex = max(0, min(lines.count, range.oldStartLine - 1))
            lines.insert(contentsOf: replacement, at: insertionIndex)
            return lines.joined(separator: "\n")
        }

        let start = range.oldStartLine - 1
        let end = range.oldEndLine - 1
        guard start >= 0, end >= start, end < lines.count else {
            throw MarkdownPatchError.invalidLineRange
        }

        let currentBlock = lines[start...end].joined(separator: "\n")
        guard currentBlock == range.before else {
            throw MarkdownPatchError.staleHunk
        }

        lines.replaceSubrange(start...end, with: range.after.isEmpty ? [] : replacement)
        return lines.joined(separator: "\n")
    }
}
```

- [ ] **Step 4: Run verification**

Run:

```bash
swift build
swift test --filter MarkdownPatchEngineTests
```

Expected: `swift build` passes. `swift test` passes with full Xcode or fails only with `no such module 'XCTest'` on CommandLineTools.

- [ ] **Step 5: Commit**

```bash
git add Sources/GraftCore/Review/MarkdownPatchEngine.swift Tests/GraftCoreTests/MarkdownPatchEngineTests.swift
git commit -m "feat: add markdown hunk patch engine"
```

---

### Task 2: Add Native Markdown Editor Bridge

**Files:**
- Create: `Sources/Graft/Views/MarkdownTextView.swift`
- Create: `Sources/Graft/Models/EditorSelection.swift`
- Create: `Sources/Graft/Services/MarkdownSyntaxHighlighter.swift`
- Modify: `Sources/Graft/Stores/WorkspaceStore.swift`

- [ ] **Step 1: Create selection model**

Create `Sources/Graft/Models/EditorSelection.swift`:

```swift
import Foundation

struct EditorSelection: Equatable {
    var range: NSRange = NSRange(location: 0, length: 0)
    var line: Int = 1
    var selectedText: String = ""
}
```

- [ ] **Step 2: Add selection state to `WorkspaceStore`**

Add this published property to `Sources/Graft/Stores/WorkspaceStore.swift`:

```swift
@Published var editorSelection = EditorSelection()
```

Add this method:

```swift
func updateEditorSelection(range: NSRange, selectedText: String) {
    let prefix = String(editorText.prefix(max(0, min(range.location, editorText.count))))
    let line = prefix.components(separatedBy: .newlines).count
    editorSelection = EditorSelection(range: range, line: line, selectedText: selectedText)
}
```

- [ ] **Step 3: Implement syntax highlighter**

Create `Sources/Graft/Services/MarkdownSyntaxHighlighter.swift`:

```swift
import AppKit
import SwiftUI

struct MarkdownSyntaxHighlighter {
    func attributedString(from markdown: String, fontSize: Double) -> NSAttributedString {
        let baseFont = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        let attributed = NSMutableAttributedString(
            string: markdown,
            attributes: [
                .font: baseFont,
                .foregroundColor: NSColor(GraftTheme.ink)
            ]
        )

        applyLineAttributes(to: attributed, markdown: markdown, fontSize: fontSize, pattern: #"^#{1,6}\s.*$"#, color: NSColor(GraftTheme.teal), weight: .semibold)
        applyLineAttributes(to: attributed, markdown: markdown, fontSize: fontSize, pattern: #"^>\s.*$"#, color: NSColor(GraftTheme.muted), weight: .regular)
        applyLineAttributes(to: attributed, markdown: markdown, fontSize: fontSize, pattern: #"^(\-|\*|\d+\.)\s.*$"#, color: NSColor(GraftTheme.ink), weight: .regular)
        applyInlineAttributes(to: attributed, markdown: markdown, pattern: #"`[^`]+`"#, color: NSColor(GraftTheme.pink))
        applyInlineAttributes(to: attributed, markdown: markdown, pattern: #"\!\[[^\]]*\]\([^\)]+\)"#, color: NSColor(GraftTheme.teal))
        applyInlineAttributes(to: attributed, markdown: markdown, pattern: #"\[[^\]]+\]\([^\)]+\)"#, color: NSColor(GraftTheme.lavender))

        return attributed
    }

    private func applyLineAttributes(to attributed: NSMutableAttributedString, markdown: String, fontSize: Double, pattern: String, color: NSColor, weight: NSFont.Weight) {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines]) else { return }
        let fullRange = NSRange(markdown.startIndex..<markdown.endIndex, in: markdown)
        regex.enumerateMatches(in: markdown, range: fullRange) { match, _, _ in
            guard let range = match?.range else { return }
            attributed.addAttributes([
                .foregroundColor: color,
                .font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: weight)
            ], range: range)
        }
    }

    private func applyInlineAttributes(to attributed: NSMutableAttributedString, markdown: String, pattern: String, color: NSColor) {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return }
        let fullRange = NSRange(markdown.startIndex..<markdown.endIndex, in: markdown)
        regex.enumerateMatches(in: markdown, range: fullRange) { match, _, _ in
            guard let range = match?.range else { return }
            attributed.addAttribute(.foregroundColor, value: color, range: range)
        }
    }
}
```

- [ ] **Step 4: Implement AppKit text bridge**

Create `Sources/Graft/Views/MarkdownTextView.swift`:

```swift
import AppKit
import SwiftUI

struct MarkdownTextView: NSViewRepresentable {
    @Binding var text: String
    var fontSize: Double
    var onSelectionChange: (NSRange, String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.hasVerticalScroller = true

        let textView = NSTextView()
        textView.delegate = context.coordinator
        textView.isRichText = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.allowsUndo = true
        textView.backgroundColor = .clear
        textView.textContainerInset = NSSize(width: 18, height: 18)
        textView.minSize = NSSize(width: 0, height: 0)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.textContainer?.widthTracksTextView = true

        scrollView.documentView = textView
        context.coordinator.textView = textView
        context.coordinator.apply(text: text, fontSize: fontSize)
        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        context.coordinator.parent = self
        guard let textView = scrollView.documentView as? NSTextView else { return }
        if textView.string != text {
            context.coordinator.apply(text: text, fontSize: fontSize)
        }
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MarkdownTextView
        weak var textView: NSTextView?
        private let highlighter = MarkdownSyntaxHighlighter()

        init(_ parent: MarkdownTextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView else { return }
            parent.text = textView.string
            apply(text: textView.string, fontSize: parent.fontSize, preserving: textView.selectedRange())
        }

        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView else { return }
            let selected = (textView.string as NSString).substring(with: textView.selectedRange().intersection(NSRange(location: 0, length: textView.string.utf16.count)))
            parent.onSelectionChange(textView.selectedRange(), selected)
        }

        func apply(text: String, fontSize: Double, preserving selection: NSRange? = nil) {
            guard let textView else { return }
            let selectedRange = selection ?? textView.selectedRange()
            textView.textStorage?.setAttributedString(highlighter.attributedString(from: text, fontSize: fontSize))
            textView.setSelectedRange(selectedRange.clamped(toLength: text.utf16.count))
        }
    }
}

private extension NSRange {
    func intersection(_ other: NSRange) -> NSRange {
        NSIntersectionRange(self, other)
    }

    func clamped(toLength length: Int) -> NSRange {
        NSRange(location: min(location, length), length: min(self.length, max(0, length - min(location, length))))
    }
}
```

- [ ] **Step 5: Build**

Run:

```bash
swift build
```

Expected: build succeeds.

- [ ] **Step 6: Commit**

```bash
git add Sources/Graft/Views/MarkdownTextView.swift Sources/Graft/Models/EditorSelection.swift Sources/Graft/Services/MarkdownSyntaxHighlighter.swift Sources/Graft/Stores/WorkspaceStore.swift
git commit -m "feat: add native markdown editor bridge"
```

---

### Task 3: Replace `TextEditor` With The Native Editor

**Files:**
- Modify: `Sources/Graft/Views/MarkdownEditorView.swift`
- Modify: `Sources/Graft/Views/ContentView.swift`

- [ ] **Step 1: Replace the `TextEditor` block**

In `Sources/Graft/Views/MarkdownEditorView.swift`, replace the current `TextEditor` with:

```swift
MarkdownTextView(
    text: $workspace.editorText,
    fontSize: workspace.editorFontSize,
    onSelectionChange: { range, selectedText in
        workspace.updateEditorSelection(range: range, selectedText: selectedText)
    }
)
.background(GraftTheme.canvas)
```

- [ ] **Step 2: Add current-line status**

In `Sources/Graft/Views/ContentView.swift`, update `StatusStrip` to include:

```swift
Text("Line \(workspace.editorSelection.line)")
    .foregroundStyle(GraftTheme.body)
```

Place it after the word count.

- [ ] **Step 3: Verify source editing**

Run:

```bash
swift build
./script/build_and_run.sh --verify
```

Expected: build succeeds and app launches.

- [ ] **Step 4: Manual check**

In the app:

- Open `SampleVault/welcome.md`.
- Type text into the editor.
- Select text and confirm the status strip line number changes.
- Save and confirm `SampleVault/welcome.md` changes on disk.

- [ ] **Step 5: Commit**

```bash
git add Sources/Graft/Views/MarkdownEditorView.swift Sources/Graft/Views/ContentView.swift
git commit -m "feat: use native markdown text editor"
```

---

### Task 4: Add Hunk-Level Review Actions

**Files:**
- Modify: `Sources/Graft/Stores/WorkspaceStore.swift`
- Modify: `Sources/Graft/Views/InlineDiffView.swift`

- [ ] **Step 1: Add hunk actions to `WorkspaceStore`**

Add these methods:

```swift
func accept(_ range: ChangeRange, from changeSet: ChangeSet) {
    guard let selectedFile, selectedFile.relativePath == changeSet.filePath else { return }
    do {
        let patched = try MarkdownPatchEngine().apply(range, to: editorText)
        snapshotCurrentDocument(reason: "Before accepting hunk from \(changeSet.authorName)", source: "Graft")
        editorText = patched
        try patched.write(to: selectedFile.url, atomically: true, encoding: .utf8)
        lastLoadedText = patched
        fileBaselines[selectedFile.url] = patched
        watcher.markClean(selectedFile.url)
        remove(range, from: changeSet, accepted: true)
        externalChangeBanner = "Accepted one hunk from \(changeSet.authorName)."
    } catch MarkdownPatchError.staleHunk {
        markReviewConflict(changeSet, currentText: editorText)
        externalChangeBanner = "That hunk no longer matches your draft. Review it as a conflict."
    } catch {
        externalChangeBanner = "Could not accept hunk: \(error.localizedDescription)"
    }
}

func reject(_ range: ChangeRange, from changeSet: ChangeSet) {
    remove(range, from: changeSet, accepted: false)
    externalChangeBanner = "Rejected one hunk from \(changeSet.authorName)."
}

private func remove(_ range: ChangeRange, from changeSet: ChangeSet, accepted: Bool) {
    var remaining = changeSet.ranges
    remaining.removeAll { $0.id == range.id }
    if remaining.isEmpty {
        updateReview(changeSet, status: accepted ? .accepted : .rejected)
        return
    }
    let updated = ChangeSet(
        id: changeSet.id,
        filePath: changeSet.filePath,
        authorName: changeSet.authorName,
        authorKind: changeSet.authorKind,
        status: changeSet.status,
        summary: changeSet.summary,
        createdAt: changeSet.createdAt,
        baseText: editorText,
        proposedText: changeSet.proposedText,
        ranges: remaining
    )
    guard let workspaceURL else { return }
    let store = ChangeSetStore(workspaceURL: workspaceURL)
    try? store.delete(changeSet)
    try? store.write(updated)
    if let index = pendingChangeSets.firstIndex(where: { $0.id == changeSet.id }) {
        pendingChangeSets[index] = updated
    }
}
```

- [ ] **Step 2: Add hunk buttons to `InlineDiffView`**

Change `InlineDiffView` properties:

```swift
let onAcceptRange: (ChangeRange) -> Void
let onRejectRange: (ChangeRange) -> Void
```

Inside each `ForEach(changeSet.ranges)` block, add:

```swift
HStack {
    Spacer()
    Button("Reject hunk") {
        onRejectRange(range)
    }
    Button("Accept hunk") {
        onAcceptRange(range)
    }
    .buttonStyle(.bordered)
}
```

- [ ] **Step 3: Wire callbacks in `MarkdownEditorView`**

Update `InlineDiffView` call:

```swift
InlineDiffView(
    changeSet: changeSet,
    onAccept: { workspace.accept(changeSet) },
    onReject: { workspace.reject(changeSet) },
    onAcceptRange: { range in workspace.accept(range, from: changeSet) },
    onRejectRange: { range in workspace.reject(range, from: changeSet) }
)
```

- [ ] **Step 4: Verify**

Run:

```bash
swift build
```

Expected: build succeeds.

- [ ] **Step 5: Commit**

```bash
git add Sources/Graft/Stores/WorkspaceStore.swift Sources/Graft/Views/InlineDiffView.swift Sources/Graft/Views/MarkdownEditorView.swift
git commit -m "feat: support hunk-level review actions"
```

---

### Task 5: Add Conflict Resolution View

**Files:**
- Create: `Sources/Graft/Views/ConflictResolutionView.swift`
- Modify: `Sources/Graft/Views/InlineDiffView.swift`

- [ ] **Step 1: Create conflict view**

Create `Sources/Graft/Views/ConflictResolutionView.swift`:

```swift
import GraftCore
import SwiftUI

struct ConflictResolutionView: View {
    let range: ChangeRange
    let onKeepCurrent: () -> Void
    let onUseProposed: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Conflict", systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
                .foregroundStyle(GraftTheme.pink)

            HStack(alignment: .top, spacing: 12) {
                ConflictColumn(title: "Current draft", text: range.before, tint: GraftTheme.pink.opacity(0.12))
                ConflictColumn(title: "Agent proposal", text: range.after, tint: GraftTheme.mint.opacity(0.20))
            }

            HStack {
                Spacer()
                Button("Keep current", action: onKeepCurrent)
                Button("Use proposal", action: onUseProposed)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(12)
        .background(GraftTheme.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(GraftTheme.pink.opacity(0.5), lineWidth: 1)
        }
    }
}

private struct ConflictColumn: View {
    let title: String
    let text: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(GraftTheme.muted)
            Text(text.isEmpty ? "Empty block" : text)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(GraftTheme.ink)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(tint)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}
```

- [ ] **Step 2: Use conflict view for conflict change sets**

In `InlineDiffView`, inside the range loop:

```swift
if changeSet.status == .conflict || range.isConflict {
    ConflictResolutionView(
        range: range,
        onKeepCurrent: { onRejectRange(range) },
        onUseProposed: { onAcceptRange(range) }
    )
} else {
    // existing current/proposed diff block rendering
}
```

- [ ] **Step 3: Verify**

Run:

```bash
swift build
```

Expected: build succeeds.

- [ ] **Step 4: Commit**

```bash
git add Sources/Graft/Views/ConflictResolutionView.swift Sources/Graft/Views/InlineDiffView.swift
git commit -m "feat: add explicit conflict resolution UI"
```

---

### Task 6: Improve Image Blocks

**Files:**
- Modify: `Sources/Graft/Services/ImageImportService.swift`
- Modify: `Sources/Graft/Views/MarkdownPreviewView.swift`
- Modify: `Sources/Graft/Stores/WorkspaceStore.swift`

- [x] **Step 1: Make imported image paths deterministic**

In `ImageImportService`, ensure images for `notes/welcome.md` land under:

```text
assets/notes/welcome/<filename>
```

Use this helper:

```swift
private func assetFolder(for file: MarkdownFile) -> URL {
    let stem = file.relativePath
        .replacingOccurrences(of: ".md", with: "")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: " ", with: "-")
    return workspaceURL
        .appendingPathComponent("assets", isDirectory: true)
        .appendingPathComponent(stem, isDirectory: true)
}
```

- [x] **Step 2: Add filename collision handling**

Use this helper:

```swift
private func availableURL(in folder: URL, filename: String) -> URL {
    let original = folder.appendingPathComponent(filename)
    guard FileManager.default.fileExists(atPath: original.path) else {
        return original
    }
    let ext = original.pathExtension
    let stem = original.deletingPathExtension().lastPathComponent
    var index = 2
    while true {
        let candidate = folder.appendingPathComponent("\(stem)-\(index).\(ext)")
        if !FileManager.default.fileExists(atPath: candidate.path) {
            return candidate
        }
        index += 1
    }
}
```

- [x] **Step 3: Add preview image block metadata**

In `MarkdownPreviewView`, render local images with:

```swift
Text(image.alt.isEmpty ? "No alt text" : image.alt)
    .font(.caption.weight(.semibold))
    .foregroundStyle(GraftTheme.ink)
Text(image.path)
    .font(.caption2)
    .foregroundStyle(GraftTheme.muted)
    .textSelection(.enabled)
```

Keep the actual image visible above the metadata.

- [ ] **Step 4: Verify image import**

Run:

```bash
swift build
```

Manual check:

- Launch Graft.
- Open `SampleVault`.
- Insert an image into `welcome.md`.
- Confirm Markdown uses a relative path under `assets/welcome/`.
- Confirm the preview shows the image, alt text, and path.

Build verification was run for the scoped slice. Manual app image insertion remains open unless a follow-up run launches Graft and checks the UI directly.

- [ ] **Step 5: Commit**

```bash
git add Sources/Graft/Services/ImageImportService.swift Sources/Graft/Views/MarkdownPreviewView.swift Sources/Graft/Stores/WorkspaceStore.swift
git commit -m "feat: improve local markdown image blocks"
```

---

### Task 7: Update Documentation And Design Notes

**Files:**
- Modify: `README.md`
- Modify: `product_brief.md`
- Modify: `design.md`
- Modify: `docs/superpowers/plans/2026-06-20-graft-agent-review-loop.md`

- [x] **Step 1: Update README**

Add to the implemented feature list:

```markdown
- Native Markdown editor bridge with syntax highlighting and line selection state.
- Hunk-level agent review actions.
- Explicit conflict resolution view.
- Local image block metadata for alt text and relative paths.
```

- [x] **Step 2: Update product brief**

Under current scope, add:

```markdown
The document surface now prioritizes block-level review. Users can accept or reject individual hunks, keep their current draft during conflicts, and inspect local image paths without leaving the editor.
```

- [x] **Step 3: Update design system**

Under future design work, move these items into current document-surface rules:

```markdown
- Syntax-highlighted Markdown source editing.
- Hunk-level review controls at the changed block.
- Conflict columns for current draft vs agent proposal.
- Image blocks with visible alt text and local path metadata.
```

- [x] **Step 4: Add completion note to previous plan**

For this scoped implementation, the follow-up note was added to `docs/superpowers/plans/2026-06-16-graft-markdown-editor.md` because it was inside the allowed write scope. The original broader instruction was:

```markdown
> Follow-up plan: document surface V2 lives in `docs/superpowers/plans/2026-06-20-graft-document-review-surface-v2.md`.
```

- [ ] **Step 5: Run copy scan**

Run:

```bash
rg -n "multiplayer|email invite|invitees|connected agents|Obsidian-style|fake|submit-change <vault> <file> --author" README.md product_brief.md design.md docs/superpowers/plans SampleVault Sources skills
```

Expected: no misleading product claims remain.

- [ ] **Step 6: Commit**

```bash
git add README.md product_brief.md design.md docs/superpowers/plans/2026-06-20-graft-agent-review-loop.md
git commit -m "docs: document review surface v2"
```

---

### Task 8: Final Verification

**Files:**
- Modify: implementation files only if verification exposes issues.

- [ ] **Step 1: Run build verification**

Run:

```bash
swift build
./script/build_and_run.sh --verify
```

Expected: both commands exit `0`.

- [ ] **Step 2: Run CLI smoke**

Run:

```bash
tmp=$(mktemp -d /tmp/graft-vault.XXXXXX)
printf '# Temp\n\nOld paragraph.\n' > "$tmp/note.md"
mkdir -p "$tmp/.graft/changes"
printf '{"filePath":"note.md","agent":"codex","summary":"Minimal metadata"}\n' > "$tmp/.graft/changes/20260620-codex.json"
swift run graft-cli history "$tmp" note.md
rm -rf "$tmp"
```

Expected output includes:

```text
Submitted changes:
20260620-codex
```

- [ ] **Step 3: Run XCTest if available**

Run:

```bash
swift test --filter GraftCoreTests
```

Expected with full Xcode: tests pass.  
Expected with CommandLineTools-only Swift on this machine: fails before tests run with `no such module 'XCTest'`. If that happens, report the environment limitation and do not claim tests passed.

- [ ] **Step 4: Manual app check**

In Graft:

- Open a Markdown workspace.
- Type in the native editor.
- Confirm syntax highlighting appears.
- Trigger or load a pending agent edit.
- Accept one hunk.
- Reject one hunk.
- Trigger a conflict and confirm current/proposed columns appear.
- Insert an image and confirm relative path metadata renders.

- [ ] **Step 5: Commit verification fixes**

If fixes were needed:

```bash
git add Sources Tests README.md product_brief.md design.md docs/superpowers/plans skills
git commit -m "fix: verify document review surface v2"
```

If no fixes were needed, do not create an empty commit.

---

## Out Of Scope For This Plan

- Cloud sync.
- Account workspaces.
- Real-time collaboration.
- Embedded Codex or Claude Code terminals.
- Git commit or branch UI.
- A proprietary document database.
- CRDT merging.

## Self-Review

- Spec coverage: The plan covers the next product step after the review loop: native editor bridge, syntax highlighting, hunk-level review, conflict UI, image block improvements, docs, and verification.
- Placeholder scan: The plan contains concrete files, code snippets, commands, and expected outputs.
- Type consistency: `MarkdownPatchEngine`, `MarkdownPatchError`, `MarkdownTextView`, `EditorSelection`, `MarkdownSyntaxHighlighter`, and `ConflictResolutionView` are introduced before later tasks reference them.
