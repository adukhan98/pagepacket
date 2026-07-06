---
name: graft-sync
description: Coordinate coding-agent edits with Graft Markdown workspaces
---

# Graft Sync

Use this skill when editing Markdown files inside a Graft workspace. Graft workspaces are plain folders with Markdown files and a `.graft/` sidecar for local history and optional agent review metadata.

## Workflow

1. Read `AGENTS.md` at the vault root if it exists. Follow its local editing contract before making changes.
2. Run `swift run graft-cli status <vault>` from the Graft project root, or run the installed `graft-cli` binary if it is already on `PATH`.
3. Before broad edits, create a checkpoint:

   ```bash
   swift run graft-cli snapshot <vault> <relative-file.md> --message "Before agent edits"
   ```

4. Edit normal Markdown files directly. Keep changes scoped to the files the user asked you to change.
5. Preserve the document's existing formatting conventions, heading levels, link style, image paths, front matter, and surrounding whitespace unless the user explicitly asks to change them.
6. Register the completed edit with optional review metadata:

   ```bash
   swift run graft-cli submit-change <vault> <relative-file.md> --agent codex --summary "Tightened welcome copy"
   ```

   This writes `.graft/changes/<timestamp>-<agent>.json` so Graft can show a better review summary. If the CLI is unavailable, you may write compatible JSON manually with `filePath`, `agent`, `authorName`, `authorKind`, `summary`, `status`, `source`, and `createdAt`.
7. Let Graft handle review, diff display, acceptance, rejection, and conflict resolution. Do not edit `.graft/reviews/` by hand.
8. If Graft reports an external-change conflict, stop and let the user choose between the disk version and the app buffer.

## Rules For Agents

- Treat `.md` files as canonical.
- Make the smallest Markdown edits that satisfy the request.
- Keep images in the vault `assets/` folder and link them with relative Markdown paths.
- Prefer one checkpoint before a multi-file change and one submit-change record after each changed document.
- Never delete `.graft/history/` unless the user explicitly asks.
- Do not bypass Graft's review lane by modifying `.graft/reviews/` or marking changes accepted/rejected yourself.
- Do not claim collaboration, sync, sharing, or email work happened unless the app or the user's tools actually performed it.

## Commands

```bash
swift run graft-cli status SampleVault
swift run graft-cli snapshot SampleVault welcome.md --message "Before Codex edits"
swift run graft-cli submit-change SampleVault welcome.md --agent codex --summary "Tightened welcome copy"
swift run graft-cli history SampleVault welcome.md
```
