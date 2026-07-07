# pagepacket

![pagepacket logo](Assets/Brand/graft-logo-lockup.png)

pagepacket is a premium local Markdown editor for macOS built around agent review. Humans edit Markdown directly. External coding agents edit the same files on disk. pagepacket turns those agent edits into reviewable inline diffs, conflicts, and checkpoints before they land.

## What is implemented

- SwiftUI macOS app with native file tree, toolbar, document review surface, review rail, and settings.
- Custom pagepacket app icon and logo assets in `Assets/Brand/`.
- Native Markdown editor bridge with syntax highlighting and line selection state.
- Edit, Preview, and Split modes for Markdown files.
- Folder-based workspace loading from real `.md` files.
- Markdown preview for headings, paragraphs, lists, tasks, quotes, tables, code fences, links, horizontal rules, and local images.
- Local image import into deterministic per-document `assets/` folders with collision-safe relative Markdown insertion.
- External file-change detection for agent edits.
- Reviewable change sets for agent edits, including inline diffs, hunk-level accept/reject controls, and conflict states.
- Explicit conflict resolution view that keeps the human draft visible beside the agent proposal.
- Local image block metadata for alt text and selectable relative paths.
- Local version snapshots in `.pagepacket/history/`.
- Restore from previous snapshots.
- Review packet metadata under `.pagepacket/changes/` and `.pagepacket/reviews/`.
- Agent activity and CLI sync contract surfaced around pending changes.
- `pagepacket-cli` commands for vault status, snapshots, submitted change metadata, apply checkpoints, and history.
- Repo-local agent skill at `skills/graft-sync/SKILL.md`.
- Build/run integration for Codex Desktop through `.codex/environments/environment.toml`.

## Run

```bash
./script/build_and_run.sh
```

Verify launch:

```bash
./script/build_and_run.sh --verify
```

## CLI

```bash
swift run pagepacket-cli status SampleVault
swift run pagepacket-cli snapshot SampleVault welcome.md --message "Before agent edits"
swift run pagepacket-cli submit-change SampleVault welcome.md --agent codex --summary "Edited welcome copy"
swift run pagepacket-cli apply SampleVault welcome.md --author codex
swift run pagepacket-cli history SampleVault welcome.md
```

## Architecture

Plain Markdown files remain canonical. pagepacket adds a sidecar folder:

```text
vault/
  welcome.md
  assets/
    welcome/
  .pagepacket/
    changes/
    history/
    reviews/
```

This keeps pagepacket agent-compatible without a backend. The product boundary is plain local Markdown plus reviewable agent edits: no account system, no cloud handoff, and no proprietary document store.
