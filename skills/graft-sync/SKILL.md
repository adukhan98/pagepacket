---
name: pagepacket-sync
description: Coordinate coding-agent edits with Pagepacket Markdown workspaces
---

# Pagepacket Sync

Use this skill when editing Markdown files inside a Pagepacket workspace. Pagepacket workspaces are plain folders with Markdown files and a `.pagepacket/` sidecar for local history and optional agent review metadata.

## Workflow

1. Read `AGENTS.md` at the vault root if it exists. Follow its local editing contract before making changes.
2. Run `swift run pagepacket-cli status <vault>` from the Pagepacket project root, or run the installed `pagepacket-cli` binary if it is already on `PATH`.
3. Before broad edits, create a checkpoint:

   ```bash
   swift run pagepacket-cli snapshot <vault> <relative-file.md> --message "Before agent edits"
   ```

4. Edit normal Markdown files directly. Keep changes scoped to the files the user asked you to change.
5. Preserve the document's existing formatting conventions, heading levels, link style, image paths, front matter, and surrounding whitespace unless the user explicitly asks to change them.
6. Register the completed edit with optional review metadata:

   ```bash
   swift run pagepacket-cli submit-change <vault> <relative-file.md> --agent codex --summary "Tightened welcome copy"
   ```

   This writes `.pagepacket/changes/<timestamp>-<agent>.json` so Pagepacket can show a better review summary. If the CLI is unavailable, you may write compatible JSON manually with `filePath`, `agent`, `authorName`, `authorKind`, `summary`, `status`, `source`, and `createdAt`.
7. Let Pagepacket handle review, diff display, acceptance, rejection, and conflict resolution. Do not edit `.pagepacket/reviews/` by hand.
8. If Pagepacket reports an external-change conflict, stop and let the user choose from the app's review controls.

## Rules For Agents

- Treat `.md` files as canonical.
- Make the smallest Markdown edits that satisfy the request.
- Keep images in the vault `assets/` folder and link them with relative Markdown paths.
- Prefer one checkpoint before a multi-file change and one submit-change record after each changed document.
- Never delete `.pagepacket/history/` unless the user explicitly asks.
- Do not bypass Pagepacket's review lane by modifying `.pagepacket/reviews/` or marking changes accepted/rejected yourself.
- Do not claim collaboration, sync, sharing, or email work happened unless the app or the user's tools actually performed it.

## Commands

```bash
swift run pagepacket-cli status SampleVault
swift run pagepacket-cli snapshot SampleVault welcome.md --message "Before Codex edits"
swift run pagepacket-cli submit-change SampleVault welcome.md --agent codex --summary "Tightened welcome copy"
swift run pagepacket-cli history SampleVault welcome.md
```
