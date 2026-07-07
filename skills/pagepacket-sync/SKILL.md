---
name: pagepacket-sync
description: Coordinate coding-agent edits with pagepacket Markdown workspaces
---

# pagepacket Sync

Use this skill when editing Markdown files inside a pagepacket workspace. pagepacket workspaces are plain folders with Markdown files and a `.pagepacket/` sidecar for local history, invite metadata, and agent coordination.

## Workflow

1. Run `swift run pagepacket-cli status <vault>` from the pagepacket project root, or run the installed `pagepacket-cli` binary if it is already on `PATH`.
2. Before broad edits, create a checkpoint:

   ```bash
   swift run pagepacket-cli snapshot <vault> <relative-file.md> --message "Before agent edits"
   ```

3. Edit normal Markdown files directly. Do not edit files under `.pagepacket/` by hand.
4. Register the completed edit:

   ```bash
   swift run pagepacket-cli apply <vault> <relative-file.md> --author codex
   ```

5. If pagepacket reports an external-change conflict, stop and let the user choose between the disk version and the app buffer.

## Rules For Agents

- Treat `.md` files as canonical.
- Keep images in the vault `assets/` folder and link them with relative Markdown paths.
- Prefer one checkpoint before a multi-file change and one apply record after each changed document.
- Never delete `.pagepacket/history/` unless the user explicitly asks.
- Do not claim email invites were sent unless the pagepacket app or the user's mail client actually composed/sent them.

## Commands

```bash
swift run pagepacket-cli status SampleVault
swift run pagepacket-cli snapshot SampleVault welcome.md --message "Before Codex edits"
swift run pagepacket-cli apply SampleVault welcome.md --author codex
swift run pagepacket-cli history SampleVault welcome.md
```
