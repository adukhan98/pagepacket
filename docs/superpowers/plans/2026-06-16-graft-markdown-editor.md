# Graft Markdown Editor Implementation Plan

> **Pivot note, 2026-06-20:** This plan is superseded for product direction by `docs/superpowers/plans/2026-06-20-graft-agent-review-loop.md`. Graft is now positioned as an agent-reviewed local Markdown editor: humans edit plain files directly, external agents propose edits through reviewable diffs, and `.graft/` stores checkpoints plus review metadata.

> **Follow-up note, 2026-06-20:** Document Review Surface V2 lives in `docs/superpowers/plans/2026-06-20-graft-document-review-surface-v2.md`. That follow-up narrows the product surface around native source editing, hunk-level review, explicit conflict resolution, and deterministic local image handling.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build Graft, a premium local-first macOS Markdown editor where humans and coding agents can edit the same plain files.

**Architecture:** SwiftPM macOS GUI app with SwiftUI shell, file-backed workspace store, Markdown preview, local version history, image import, sharing/invite metadata, and CLI coordination. Plain `.md` files remain canonical; `.graft/` stores snapshots and app metadata.

**Tech Stack:** Swift 6, SwiftUI, AppKit panels, Foundation filesystem APIs, SwiftPM app bundle staging through `script/build_and_run.sh`.

---

### Task 1: Project Scaffold

**Files:**
- Create: `Package.swift`
- Create: `Sources/Graft/App/GraftApp.swift`
- Create: `script/build_and_run.sh`
- Create: `.codex/environments/environment.toml`

- [x] Create the SwiftPM executable package and macOS app entry point.
- [x] Wire a project-local build/run script that stages `dist/Graft.app`.
- [x] Wire the Codex Desktop Run action to `./script/build_and_run.sh`.

### Task 2: Workspace Model And Store

**Files:**
- Create: `Sources/Graft/Models/*.swift`
- Create: `Sources/Graft/Stores/WorkspaceStore.swift`
- Create: `Sources/Graft/Services/FileWatcher.swift`

- [x] Load Markdown files from a selected workspace folder.
- [x] Save edited content to plain `.md` files.
- [x] Watch selected files for external agent edits and surface changes.
- [x] Store sidecar data under `.graft/`.

### Task 3: Markdown Editor And Preview

**Files:**
- Create: `Sources/Graft/Views/EditorView.swift`
- Create: `Sources/Graft/Views/PreviewView.swift`
- Create: `Sources/Graft/Services/MarkdownRenderer.swift`

- [x] Provide Edit, Preview, and Split modes.
- [x] Render headings, paragraphs, lists, tasks, quotes, tables, code blocks, links, and images.
- [x] Keep preview image paths relative to the workspace.

### Task 4: Product UI

**Files:**
- Create: `Sources/Graft/Views/ContentView.swift`
- Create: `Sources/Graft/Views/SidebarView.swift`
- Create: `Sources/Graft/Views/InspectorView.swift`
- Create: `Sources/Graft/Views/HistoryView.swift`
- Create: `Sources/Graft/Views/ShareView.swift`
- Create: `Sources/Graft/Views/Theme.swift`

- [x] Build a native macOS sidebar/editor/inspector layout.
- [x] Apply warm cream canvas, dark ink, and restrained saturated accents from `DESIGN.md`.
- [x] Expose history, agent activity, image assets, and invite sharing controls.

### Task 5: Version History, Sharing, Images, CLI

**Files:**
- Create: `Sources/Graft/Services/VersionHistoryStore.swift`
- Create: `Sources/Graft/Services/ImageImportService.swift`
- Create: `Sources/GraftCLI/main.swift`
- Create: `SampleVault/welcome.md`

- [x] Snapshot document revisions into `.graft/history/`.
- [x] Restore old revisions from the app.
- [x] Copy selected images into deterministic per-document `assets/` folders and insert relative Markdown.
- [x] Provide CLI commands for `status`, `snapshot`, `history`, and `apply`.
- [x] Provide a repo-local `skills/graft-sync/SKILL.md` workflow for coding agents.
- [x] Include a sample vault that demonstrates Markdown, images, history, and agent-safe file editing.

### Task 6: Verification

**Files:**
- Modify: implementation files as needed.

- [x] Run `swift build`.
- [x] Run `./script/build_and_run.sh --verify`.
- [x] Run `swift run graft-cli status SampleVault`.
- [x] Confirm generated app bundle launches and the process exists.
