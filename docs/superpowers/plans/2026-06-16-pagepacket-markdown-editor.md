# Pagepacket Markdown Editor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build Pagepacket, a premium local-first macOS Markdown editor where humans and coding agents can edit the same plain files.

**Architecture:** SwiftPM macOS GUI app with SwiftUI shell, file-backed workspace store, Markdown preview, local version history, image import, sharing/invite metadata, and CLI coordination. Plain `.md` files remain canonical; `.pagepacket/` stores snapshots and app metadata.

**Tech Stack:** Swift 6, SwiftUI, AppKit panels, Foundation filesystem APIs, SwiftPM app bundle staging through `script/build_and_run.sh`.

---

### Task 1: Project Scaffold

**Files:**
- Create: `Package.swift`
- Create: `Sources/Pagepacket/App/PagepacketApp.swift`
- Create: `script/build_and_run.sh`
- Create: `.codex/environments/environment.toml`

- [x] Create the SwiftPM executable package and macOS app entry point.
- [x] Wire a project-local build/run script that stages `dist/Pagepacket.app`.
- [x] Wire the Codex Desktop Run action to `./script/build_and_run.sh`.

### Task 2: Workspace Model And Store

**Files:**
- Create: `Sources/Pagepacket/Models/*.swift`
- Create: `Sources/Pagepacket/Stores/WorkspaceStore.swift`
- Create: `Sources/Pagepacket/Services/FileWatcher.swift`

- [x] Load Markdown files from a selected workspace folder.
- [x] Save edited content to plain `.md` files.
- [x] Watch selected files for external agent edits and surface changes.
- [x] Store sidecar data under `.pagepacket/`.

### Task 3: Markdown Editor And Preview

**Files:**
- Create: `Sources/Pagepacket/Views/EditorView.swift`
- Create: `Sources/Pagepacket/Views/PreviewView.swift`
- Create: `Sources/Pagepacket/Services/MarkdownRenderer.swift`

- [x] Provide Edit, Preview, and Split modes.
- [x] Render headings, paragraphs, lists, tasks, quotes, tables, code blocks, links, and images.
- [x] Keep preview image paths relative to the workspace.

### Task 4: Product UI

**Files:**
- Create: `Sources/Pagepacket/Views/ContentView.swift`
- Create: `Sources/Pagepacket/Views/SidebarView.swift`
- Create: `Sources/Pagepacket/Views/InspectorView.swift`
- Create: `Sources/Pagepacket/Views/HistoryView.swift`
- Create: `Sources/Pagepacket/Views/ShareView.swift`
- Create: `Sources/Pagepacket/Views/Theme.swift`

- [x] Build a native macOS sidebar/editor/inspector layout.
- [x] Apply warm cream canvas, dark ink, and restrained saturated accents from `DESIGN.md`.
- [x] Expose history, agent activity, image assets, and invite sharing controls.

### Task 5: Version History, Sharing, Images, CLI

**Files:**
- Create: `Sources/Pagepacket/Services/VersionHistoryStore.swift`
- Create: `Sources/Pagepacket/Services/ImageImportService.swift`
- Create: `Sources/PagepacketCLI/main.swift`
- Create: `SampleVault/welcome.md`

- [x] Snapshot document revisions into `.pagepacket/history/`.
- [x] Restore old revisions from the app.
- [x] Copy selected images into `assets/` and insert relative Markdown.
- [x] Provide CLI commands for `status`, `snapshot`, `history`, and `apply`.
- [x] Provide a repo-local `skills/pagepacket-sync/SKILL.md` workflow for coding agents.
- [x] Include a sample vault that demonstrates Markdown, images, history, and agent-safe file editing.

### Task 6: Verification

**Files:**
- Modify: implementation files as needed.

- [x] Run `swift build`.
- [x] Run `./script/build_and_run.sh --verify`.
- [x] Run `swift run pagepacket-cli status SampleVault`.
- [x] Confirm generated app bundle launches and the process exists.
