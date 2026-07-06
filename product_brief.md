# Graft Product Brief

## Overview

Graft is a premium local Markdown editor for macOS built for a new writing loop: people write directly, coding agents edit the same plain files, and Graft makes every agent change reviewable before it lands.

Markdown files remain normal files on disk. Graft adds a `.graft/` sidecar for checkpoints, pending change sets, review metadata, and agent instructions. The product does not require a proprietary document format or a cloud account to be useful.

## Positioning

Graft is an agent-reviewed Markdown editor.

The core promise:

> Write in plain Markdown while Graft turns agent edits into clean review packets.

Traditional Markdown editors assume one author at the keyboard. Graft assumes a person is still in control, but Codex, Claude Code, Cursor, shell scripts, and other external tools may also edit the workspace. The product makes those edits visible, comparable, and reversible.

## Target Users

- Developers using coding agents to update documentation, specs, release notes, and project plans.
- Writers and operators who keep long-form work, briefs, and research notes in Markdown.
- AI-native product teams that need agent accountability around generated or edited text.
- Local-first users who want durable plain files with a stronger review loop than a text editor can provide.

## Core Product Principles

### Plain Files First

Graft workspaces are normal folders containing `.md` files. The app does not import content into a database or proprietary document format.

This means:

- Markdown stays portable.
- Files can be edited by any text editor.
- Coding agents can edit files directly.
- Git, shell tools, and automation workflows continue to work.

### Humans Own The Draft

Human edits save directly to disk. Agent edits enter a review lane. When human and agent changes touch the same range, Graft keeps the human text by default and marks the agent edit as a conflict.

### Review Before Replace

When an external tool changes a file, Graft captures the proposed version as a change set. The user reviews inline diffs, accepts or rejects specific hunks, and can checkpoint before applying broad changes.

### Durable Checkpoints

Meaningful checkpoints live in `.graft/history/`. They protect the user before agent edits, before restores, before accepting review packets, and during manual checkpoints.

### Premium Native Mac Feel

The app uses a native macOS structure: file tree, toolbar, document review surface, review rail, settings, and status strip. The visual system is warm and crafted, but the editor remains calm, dense, and practical.

## Key Features

### 1. Markdown Workspace Editing

Users open a folder as a Graft workspace and edit real `.md` files directly.

The app includes:

- Workspace-based file loading.
- File tree for Markdown documents.
- Native editor surface with Markdown syntax highlighting and line selection state.
- Save support back to the original file.
- Dirty/saved status indicator.

This keeps Graft compatible with existing Markdown folders, Git repositories, documentation directories, and agent-edited project files.

### 2. Document Modes

Graft supports three document modes:

- **Edit**: focused Markdown source editing.
- **Preview**: rendered Markdown reading mode.
- **Split**: source editor and rendered preview side by side.

The default product surface should lead with file tree + document review + review rail. Preview remains important, but the differentiator is reviewable agent change.

### 3. Markdown Rendering

The preview renderer supports the Markdown patterns needed for practical documentation and writing workflows:

- Headings.
- Paragraphs.
- Bold, links, and inline Markdown handled through attributed text.
- Unordered lists.
- Ordered lists.
- Task lists.
- Block quotes.
- Code fences with optional language labels.
- Tables.
- Horizontal rules.
- Local images.

This gives users a readable preview without losing the plain Markdown source.

### 4. Agent Review Loop

Graft is built around the assumption that external agents may edit the same files a person is viewing or editing.

The document surface now prioritizes block-level review. Users can accept or reject individual hunks, keep their current draft during conflicts, and inspect local image paths without leaving the editor.

The app should surface:

- External file-change detection.
- Pending agent change sets.
- Inline diffs grouped by Markdown block.
- Conflict states when human edits overlap with agent edits.
- Accept/reject controls for reviewable changes.
- Checkpoints before accepting broad edits.
- Lightweight author metadata such as "Agent edit" and source name when available.

The goal is not to hide the file system from agents. The goal is to make file-system collaboration visible, reviewable, and recoverable.

### 5. Version History

Graft stores local checkpoints in:

```text
.graft/history/
```

Checkpoints include document path, source, reason, timestamp, and the Markdown content at that moment.

Version history supports:

- Manual checkpoints.
- Checkpoints before save.
- Checkpoints before restore.
- Checkpoints before accepting review packets.
- History timeline in the review rail.
- Restore from a previous checkpoint.
- CLI-created checkpoints for agent workflows.

This gives users confidence when asking agents to make broad edits.

### 6. Review Packets

Sharing language becomes review packet language.

A review packet is a local description of proposed changes. Agents can optionally write metadata under:

```text
.graft/changes/
```

Graft can persist review state under:

```text
.graft/reviews/
```

Review packets can include:

- File path.
- Author/source.
- Summary.
- Proposed Markdown.
- Changed ranges.
- Conflict flags.
- Review status.

This is deliberately local and file-native. Account membership, permissions, delivery, and cloud workflows are outside the v1 promise.

### 7. CLI Sync For Agents

Graft includes a CLI companion, `graft-cli`, for agent coordination.

Current and planned command language should center on:

```bash
swift run graft-cli status <vault>
swift run graft-cli snapshot <vault> <file> --message "Before edits"
swift run graft-cli submit-change <vault> <file> --agent codex --summary "Tightened intro"
swift run graft-cli history <vault> <file>
```

The CLI helps agents:

- Inspect a workspace before editing.
- Create a checkpoint before broad changes.
- Submit scoped change metadata.
- Register completed edits with authorship/source metadata.
- List local version history.

The repo also includes a dedicated agent skill:

```text
skills/graft-sync/SKILL.md
```

That skill defines the expected workflow for coding agents editing Graft workspaces.

### 8. Image Support

Graft supports local Markdown image workflows.

Users can import an image into the workspace. Graft copies the image into an `assets/` folder and inserts a relative Markdown image reference.

Imported images live in deterministic per-document folders, and filename collisions are handled by appending a stable numeric suffix instead of replacing the existing file. The preview renders local images with visible alt text and selectable relative paths, so users can keep illustrated notes, briefs, docs, and plans inside a portable folder structure.

Recommended workspace shape:

```text
vault/
  notes.md
  assets/
    notes/
      image.png
      image-2.png
  .graft/
    changes/
    history/
    reviews/
```

### 9. Review Rail

The review rail is the metadata layer around the editor.

Panels:

- **Pending**: agent change sets waiting for review.
- **Conflicts**: overlapping human and agent edits that need explicit attention.
- **History**: checkpoints, timestamps, reasons, and restore actions.
- **Agents**: editing contract, source metadata, and CLI workflow reminders.

This keeps the editor focused while making agent state visible when needed.

### 10. Premium Branding

The app is named **Graft** because the product joins edits from multiple sources into one living document history.

The logo system uses:

- Markdown bracket symbolism.
- A grafted stem and leaves.
- A hot-pink graft seam.
- Warm cream app icon tile.
- Deep teal and mint brand elements.

This matches the product idea: structured text that grows through human writing and reviewed agent edits.

## Technical Model

Graft is a SwiftUI macOS app with a SwiftPM package structure.

Core pieces:

- `WorkspaceStore`: workspace state, document loading, saves, checkpoints, review packets, image imports, and external-change handling.
- `GraftCore`: pure Swift review logic for change sets, diffing, metadata parsing, and checkpoint rules.
- `MarkdownRenderer`: lightweight Markdown block parsing for preview.
- `FileWatcher`: detects file changes from external tools.
- `VersionHistoryStore`: writes and reads local checkpoints.
- `ImageImportService`: copies images into workspace assets and returns relative Markdown.
- `graft-cli`: command-line companion for agent workflows.

The sidecar folder keeps Graft metadata separate from user-authored Markdown:

```text
.graft/
  changes/
  history/
  reviews/
```

## Current V1 Scope

The current product direction is a working local-first document review surface.

It includes or should converge on:

- Native macOS app.
- Native Markdown file editing with syntax highlighting.
- Preview and split mode.
- External agent edit detection.
- Reviewable inline diffs.
- Hunk-level accept/reject controls.
- Explicit conflict handling with human edits winning by default.
- Local version checkpoints.
- Restore from checkpoints.
- Review packet metadata.
- CLI sync workflow.
- Agent skill.
- Image import, deterministic per-document asset folders, and local image preview metadata.
- Custom logo and macOS app icon.

## Future Product Direction

Graft should earn larger collaboration features by first making the local file review loop excellent.

Future additions could include:

- Commenting on review packets.
- Team packet export/import.
- Cloud sync across devices.
- Account-based workspaces.
- Remote agent activity across machines.
- Git-aware change grouping.
- Outline navigation.
- Polished dark mode.

## Differentiation

Graft is different because it does not force a choice between a beautiful Markdown editor and agent-compatible plain files.

It gives users:

- The comfort of a premium native Mac editor.
- The portability of normal Markdown files.
- The safety of local checkpoints.
- The transparency of visible agent edits.
- The control of reviewable inline diffs.
- The extensibility of a CLI and skill workflow.

That combination is the product's wedge: **a Markdown editor built for agent-reviewed writing.**
