# Welcome to Graft

Graft is a local-first Markdown editor for people and coding agents.

- Edit plain `.md` files in the app.
- Let Codex, Claude Code, Cursor, Hermes, or shell scripts edit the same files.
- Use local snapshots in `.graft/history` before broad changes.
- Keep images portable with relative Markdown links.

## Obsidian-style workflow

Switch between **Edit**, **Split**, and **Preview** modes. The editor writes real Markdown, and the preview renders headings, lists, tasks, code, quotes, links, and local images.

> The file system is the source of truth. Graft adds history and collaboration metadata beside it.

## Tasks

- [x] Keep Markdown portable
- [x] Watch for external agent edits
- [ ] Connect cloud multiplayer and real email invites

## Agent support matrix

| Agent | Works today | Recommended command |
|---|---:|---|
| Codex | yes | `graft-cli snapshot` |
| Claude Code | yes | `graft-cli apply` |
| Cursor | yes | edit `.md` directly |
| Hermes | yes | check `graft-cli status` |

## Agent CLI

```bash
graft-cli status SampleVault
graft-cli snapshot SampleVault welcome.md --message "Before Codex edits"
graft-cli apply SampleVault welcome.md --author codex
```

## Image support

![Graft sample image](assets/welcome/graft-sample.ppm)
