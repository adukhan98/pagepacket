# Graft Design System

## Purpose

This file captures the product design decisions for Graft, the local macOS Markdown editor for humans working with coding agents.

The original visual reference lives in `docs/reference/clay-design-reference.md`. That file describes the Clay-inspired source material: warm cream canvas, dark ink, saturated accent cards, rounded typography, and tactile 3D craft. This file translates those ideas into Graft's actual product interface and brand system.

## Design Thesis

Graft should feel like a premium native Mac productivity app, not a marketing page.

The interface should be:

- Warm, crafted, and memorable.
- Dense enough for real writing and repeated daily use.
- Native enough to feel at home on macOS.
- Playful in brand details, not noisy in the editor.
- Clearly built for direct human writing plus reviewed agent edits.

The product metaphor is **structured text that grows through review**. The app joins human edits, agent proposals, checkpoints, and review metadata into one living document history.

## Brand Name

The selected name is **Graft**.

Why it works:

- It suggests joining multiple contributions into one living whole.
- It fits version history and agent review.
- It feels short, premium, and memorable.
- It avoids generic AI naming.
- It connects naturally to the selected bracket-and-leaf logo.

## Logo Direction

The selected logo direction is a **Markdown bracket symbol grafted into a small two-leaf stem with a hot-pink wrap/seam**.

### Core Meaning

- **Brackets**: Markdown, code, structured text, editor surface.
- **Stem and leaves**: living documents, growth, durable knowledge.
- **Pink wrap/seam**: the graft point where human writing and reviewed agent edits join.
- **Cream tile**: premium macOS app icon, warm and tactile.

### Logo Assets

- Full lockup: `Assets/Brand/graft-logo-lockup.png`
- App icon PNG: `Assets/Brand/graft-app-icon.png`
- macOS icon file: `Sources/Graft/Resources/Graft.icns`

### App Icon

The app icon should use:

- Cream rounded-square tile.
- Deep teal bracket/stem.
- Mint leaves.
- Hot-pink graft wrap.
- Subtle tactile/clay-like dimensionality.

The icon should not include the wordmark inside the app tile.

### Wordmark

The wordmark should be:

- Dark ink.
- Rounded, medium-weight, editorial.
- Simple enough to pair with the icon.
- Never overly futuristic, cyber, or generic AI-styled.

## Visual Personality

Graft inherits warmth and craft from the Clay-style reference, but uses it in a product-first way.

Do:

- Use warm cream surfaces.
- Use dark ink text.
- Use saturated accents for review states, history, images, and agent changes.
- Keep controls familiar and macOS-native.
- Use rounded geometry and soft tactile details.
- Let the editor content remain the focus.

Do not:

- Turn the app into a marketing landing page.
- Fill the UI with decorative blobs, oversized hero sections, or ornamental cards.
- Use generic AI sparkle branding.
- Use dark cyber colors.
- Use thin line-art logos or fragile icons.
- Make the workspace feel childish or toy-like.

## Color System

The palette comes from the provided design reference, adapted for a desktop product.

### Core Colors

| Role | Hex | Use |
|---|---:|---|
| Warm Canvas | `#fffaf0` | Main editor and app background |
| Surface Soft | `#faf5e8` | Preview pane, review rail, header strips |
| Surface Card | `#f5f0e0` | History cards, review packets, agent cards |
| Ink | `#0a0a0a` | Main text, wordmark, key labels |
| Body | `#3a3a3a` | Secondary body text |
| Muted | `#6a6a6a` | Captions, metadata, file paths |

### Accent Colors

| Role | Hex | Use |
|---|---:|---|
| Hot Pink | `#ff4d8b` | Graft seam, dirty/conflict states, high-signal accents |
| Deep Teal | `#1a3a3a` | Brackets, primary brand mark, stable review state |
| Lavender | `#b8a4ed` | Pending change banners, preview highlights |
| Peach | `#ffb084` | Empty-state icon layers, warmth |
| Ochre | `#e8b94a` | Checkpoint timeline markers, table headers |
| Mint | `#a4d4c5` | Leaves, accepted changes, editor-ready states |

### Application Rules

- Cream is the dominant background color in light mode.
- Ink is the dominant text color.
- Accent colors should appear as small signals, not full-screen themes.
- Avoid repeating one accent everywhere; rotate accents by semantic purpose.
- Do not introduce additional brand colors unless there is a clear semantic need.

## Typography

Graft uses system fonts for native macOS fit.

### UI

- Primary UI: SF Pro.
- Brand/display moments: SF Pro Rounded or rounded medium-weight fallback.
- Editor text: monospaced system font by default.

### Type Principles

- Use medium-weight rounded display type for the Graft wordmark and empty-state headlines.
- Use standard system sizes for toolbar, file tree, review rail, and settings.
- Keep editor type adjustable.
- Avoid oversized marketing-style headlines inside the app.
- Avoid negative letter spacing in dense product UI.

## App Layout

Graft uses a native macOS workspace layout.

### Main Structure

- Left file tree: workspace folders, Markdown files, and lightweight file state.
- Center document surface: raw Markdown editor, preview, split mode, and inline review.
- Right review rail: pending agent edits, conflicts, accepted changes, checkpoints, and agent workflow notes.
- Top toolbar: workspace, mode control, save, checkpoint, image, review rail.
- Bottom status strip: saved state, word count, workspace path, pending changes, local review status.

### Default Mode

Default mode is **Document Review**.

Why:

- It foregrounds the product's differentiator: agent edits become reviewable diffs.
- It keeps the human draft visible as the source of truth.
- It gives users immediate confidence that plain files can still support a structured review loop.

The initial view should show a selected Markdown file, the editor/review surface, and the compact review rail. Preview and split modes remain available, but they are secondary to reviewing proposed changes.

### File Tree

The file tree should feel native and source-list-like.

Rules:

- Flat rows, not cards.
- One leading icon per row.
- File title plus one secondary path line.
- Small badges for pending changes or conflicts.
- No presence avatars or account-membership cues.

### Document Review Surface

The center surface should prioritize writing and review.

Rules:

- Use a clean monospaced font for source editing.
- Use syntax highlighting for Markdown structure, links, image syntax, code, tasks, quotes, and lists.
- Keep the background warm but low-contrast.
- Put document title and path above the text area.
- Show pending agent diffs inline near the affected Markdown block.
- Keep accept/reject controls compact and local to the reviewed hunk.
- Put hunk-level review controls at the changed block, not only at the whole packet level.
- Show explicit conflict columns for current draft vs agent proposal when a hunk no longer applies cleanly.
- Make Save, Checkpoint, and Image actions visible but not dominant.

### Preview

The preview should feel editorial and readable.

It supports:

- Headings.
- Paragraphs.
- Lists.
- Task lists.
- Quotes.
- Code blocks.
- Tables.
- Horizontal rules.
- Local images.

Preview content should be constrained to a readable width rather than stretching across the full pane.

### Review Rail

The review rail is the agent-review layer.

Tabs or sections:

- **Pending**: review packets waiting for a decision.
- **Conflicts**: overlapping human and agent edits.
- **History**: checkpoints and restore actions.
- **Agents**: source metadata and CLI workflow reminders.

The rail can use card surfaces because its content is metadata, not the primary writing canvas.

## Component Decisions

### Toolbar

Use SF Symbols and native toolbar placement.

Important toolbar actions:

- Open Workspace.
- Edit / Review / Split / Preview mode control.
- Save.
- Checkpoint.
- Insert Image.
- Toggle Review Rail.

### Status Strip

The bottom status strip should show:

- Saved or unsaved state.
- Word count.
- Current workspace.
- Pending review count.
- Conflict count.
- `.graft local review` status.

### Review Packet Cards

Review packet cards show:

- Source.
- Summary.
- File path.
- Status: pending, accepted, rejected, or conflict.
- Changed block count.
- Created time.

Lavender is used for pending changes. Mint is used for accepted changes. Hot pink is reserved for conflicts and dirty state.

### History Cards

History cards show:

- Source.
- Reason.
- Timestamp.
- Byte count.
- Restore action.

Ochre is used as the checkpoint-history accent.

### Agent Cards

Agent cards show:

- Source name when known.
- Last change time.
- Detail text.
- Metadata availability.
- Color-coded activity dot or chip.

Agent visuals should be useful, not gimmicky. Avoid chat-bubble-first UI and avoid implying live presence unless the app can prove it.

### Image Blocks

Image blocks in preview should show:

- Rendered local image.
- Alt text or a clear "No alt text" state.
- Selectable relative path.
- Rounded preview surface.

Images should remain portable through relative Markdown links. Imported files should live in deterministic per-document asset folders, with numeric suffixes for duplicate filenames.

## Interaction Patterns

### Markdown Modes

Users can switch between:

- Edit.
- Review.
- Split.
- Preview.

This should stay visible in the toolbar.

### External Agent Edits

When a file changes on disk:

- Graft captures the disk change as a pending review packet.
- The human draft remains the source of truth while the change is reviewed.
- Inline diffs show added, removed, and changed Markdown blocks.
- If the human has edited the same range, Graft marks a conflict.
- The user can accept, reject, or checkpoint before applying the change.

This reinforces that agents can edit the same files without silently replacing the user's draft.

### Checkpoints

Checkpoints should happen:

- Manually through the toolbar.
- Before saves when useful.
- Before restores.
- Before accepting review packets.
- Through `graft-cli snapshot`.

### Review Packets

In v1, review packets are local metadata plus proposed Markdown changes.

Design copy should be honest:

- Graft reads optional metadata from `.graft/changes/`.
- Graft stores review state in `.graft/reviews/`.
- Agents may provide a summary, source, and changed-file metadata.
- Missing metadata falls back to generic labels such as "Agent edit" and "Pending change."

### CLI Sync

The app should repeatedly teach the agent workflow:

```bash
graft-cli status <vault>
graft-cli snapshot <vault> <file> --message "Before edits"
graft-cli submit-change <vault> <file> --agent codex --summary "Tightened intro"
graft-cli history <vault> <file>
```

The skill at `skills/graft-sync/SKILL.md` is part of the product experience for coding agents.

## Accessibility

Design must not rely on color alone.

Rules:

- Pair colored states with labels and icons.
- Keep editor text high contrast.
- Preserve native macOS focus and selection behavior.
- Keep controls keyboard accessible.
- Keep card radius modest in dense areas.
- Avoid text overflow in file tree rows, buttons, and cards.
- Respect the user's system font and display settings where possible.

## Dark Mode Direction

Dark mode is not fully designed yet, but the direction is:

- Use warm charcoal, not pure black.
- Use toned-down accents.
- Preserve cream/linen warmth through muted surfaces where appropriate.
- Keep editor text contrast strong.
- Keep the logo mark unchanged when possible.

## Current Implementation References

Key files:

- `Sources/Graft/Views/Theme.swift`: color tokens and card styling.
- `Sources/Graft/Views/ContentView.swift`: main shell, toolbar, status strip.
- `Sources/Graft/Views/SidebarView.swift`: file tree.
- `Sources/Graft/Views/MarkdownEditorView.swift`: source editor and inline review entry point.
- `Sources/Graft/Views/MarkdownPreviewView.swift`: rendered Markdown.
- `Sources/Graft/Views/ReviewRailView.swift`: pending changes, conflicts, checkpoints, and agent workflow.
- `Sources/Graft/Views/InlineDiffView.swift`: reviewed Markdown hunks.
- `Sources/Graft/Views/HistoryView.swift`: version history UI.
- `Assets/Brand/`: logo and app icon source assets.
- `Sources/Graft/Resources/Graft.icns`: macOS app icon.

## Future Design Work

The next design improvements should focus on:

- Command palette.
- Backlinks and outline inspector.
- Git-aware review grouping.
- Polished dark mode.

Do not start with realtime cursors or decorative collaboration effects. The strongest product path is to make local file review feel trustworthy, visible, and calm.
