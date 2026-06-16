---
name: graft-sync
description: Coordinate coding-agent edits with Graft Markdown workspaces
---

# Graft Sync

Use this skill when editing Markdown files inside a Graft workspace. Graft workspaces are plain folders with Markdown files and a `.graft/` sidecar for local history, invite metadata, and agent coordination.

## Workflow

1. Run `swift run graft-cli status <vault>` from the Graft project root, or run the installed `graft-cli` binary if it is already on `PATH`.
2. Before broad edits, create a checkpoint:

   ```bash
   swift run graft-cli snapshot <vault> <relative-file.md> --message "Before agent edits"
   ```

3. Edit normal Markdown files directly. Do not edit files under `.graft/` by hand.
4. Register the completed edit:

   ```bash
   swift run graft-cli apply <vault> <relative-file.md> --author codex
   ```

5. If Graft reports an external-change conflict, stop and let the user choose between the disk version and the app buffer.

## Rules For Agents

- Treat `.md` files as canonical.
- Keep images in the vault `assets/` folder and link them with relative Markdown paths.
- Prefer one checkpoint before a multi-file change and one apply record after each changed document.
- Never delete `.graft/history/` unless the user explicitly asks.
- Do not claim email invites were sent unless the Graft app or the user's mail client actually composed/sent them.

## Commands

```bash
swift run graft-cli status SampleVault
swift run graft-cli snapshot SampleVault welcome.md --message "Before Codex edits"
swift run graft-cli apply SampleVault welcome.md --author codex
swift run graft-cli history SampleVault welcome.md
```
