# Pagepacket Production-Scale Inventory

Run date: 2026-07-06

Fixture: `outputs/prodscale-fixtures/pagepacket-prodscale-vault`

Safety boundary: all test data is generated locally under `outputs/prodscale-fixtures/`. No production systems, real accounts, sensitive data, real email sending, or destructive shared actions are in scope.

## Roles

| ID | Role | User-facing scope | Acceptance criteria | Finite edge cases | Source evidence |
| --- | --- | --- | --- | --- | --- |
| ROLE-001 | Local writer/editor | Opens a Markdown folder, edits plain `.md` files, previews, saves, snapshots, restores, imports images, and resolves external-change conflicts. | Plain Markdown remains canonical on disk; sidecars stay under `.pagepacket/`; save/restore never require cloud access. | Empty workspace; empty file; deep file; filename with spaces; long line; hidden sidecars; save failure; restore from front-matter snapshot. | `WorkspaceStore.swift`, `MarkdownEditorView.swift`, `HistoryView.swift`, `VersionHistoryStore.swift` |
| ROLE-002 | External coding agent/tool | Edits files on disk and uses CLI snapshot/apply/status/history workflow. | App detects disk changes when enabled; CLI only writes sidecar snapshots and does not mutate Markdown content. | Nonselected file change; selected clean change; selected dirty conflict; `.pagepacket`/`.graft` exclusion; path-collision candidates. | `FileWatcher.swift`, `WorkspaceStore.swift`, `Sources/GraftCLI/main.swift` |
| ROLE-003 | Invite recipient intent roles | Viewer, Commenter, and Editor invite records can be saved locally. | Invite intent records normalize valid email addresses, reject invalid/duplicate entries, and persist to `.pagepacket/shares/invites.json`. | Invalid email; duplicate with case/whitespace; empty manifest; malformed existing records; remove invite. | `Invite.swift`, `ShareView.swift`, `WorkspaceStore.swift` |
| ROLE-004 | Landing-page visitor | Reads product positioning and joins waitlist through local preview storage or a configured endpoint. | Navigation anchors work; email validation blocks bad addresses; valid submissions set visible success/error state without production calls when action is `/waitlist`. | Invalid email; duplicate email; corrupted localStorage; custom endpoint success/failure; mobile width. | `landing page/index.html`, `landing page/script.js` |
| ROLE-005 | Developer/operator | Builds/runs the app, verifies the bundle, and runs regression/CLI/landing checks. | Validation commands finish with exit code 0 or logged blocker evidence. | SwiftPM build path isolation; unavailable XCTest; LaunchServices app launch; whitespace diff. | `Package.swift`, `script/build_and_run.sh`, `Tests/run_regression_checks.sh` |

No authenticated, admin, billing, production, cloud-sync, or real multiplayer roles were found in the current code. The Share panel stores invite intent only; it does not create real memberships.

## Routes, Screens, And Modes

| ID | Surface | Route/screen/mode | Acceptance criteria | Finite edge cases | Source evidence |
| --- | --- | --- | --- | --- | --- |
| APP-SCR-001 | macOS app | Main Pagepacket window | App launches as a regular macOS app, creates a visible window with minimum size, and bootstraps `SampleVault` when present. | First launch without sample vault; reopen after closing window; small saved frame; LaunchServices-opened bundle. | `GraftApp.swift`, `script/build_and_run.sh` |
| APP-SCR-002 | macOS app | Empty workspace state | When no file is selected, shows the empty prompt and Open Workspace action. | Empty selected file list; canceled folder picker. | `EditorContainerView.swift` |
| APP-SCR-003 | macOS app | Sidebar | Lists Markdown files with title/path and agent status rows. | 366-file fixture; hidden sidecars; nested files; files with spaces. | `SidebarView.swift`, `WorkspaceStore.reloadFileList()` |
| APP-SCR-004 | macOS app | Edit mode | Shows selected file title/path, image/save controls, and wrapping plain-text Markdown editor. | Empty file; long line; autosave on/off; dirty/saved transitions. | `MarkdownEditorView.swift`, `EditorMode.swift` |
| APP-SCR-005 | macOS app | Preview mode | Renders Markdown headings, paragraphs, quotes, lists, tasks, code, tables, images, missing images, and rules. | Repeated identical blocks; ordered list starting at non-1; missing image; relative image; malformed table; unfenced code at EOF. | `MarkdownRenderer.swift`, `MarkdownPreviewView.swift` |
| APP-SCR-006 | macOS app | Split mode | Shows editor and preview side by side. | Minimum window width; long-line wrapping; inspector hidden/visible. | `EditorContainerView.swift` |
| APP-SCR-007 | macOS app | External-change banner | Shows disk-change/review status with Accept, Reject, and dismiss controls when a selected review packet exists. | Clean selected file; dirty selected file; nonselected file; detection disabled; no selected review. | `ContentView.ExternalChangeBanner`, `WorkspaceStore.handleExternalChange()` |
| APP-SCR-008 | macOS app | Status strip | Shows Saved/Unsaved, word count, workspace name, up to three agents, and local-first sidecar text. | Empty document; no workspace; >3 agents. | `ContentView.StatusStrip` |
| APP-SCR-009 | macOS app | Inspector History tab | Shows empty state, manual checkpoint, snapshot cards, and Restore actions. | No snapshots; multiple snapshots; front-matter snapshot; path-collision files. | `InspectorView.swift`, `HistoryView.swift`, `VersionHistoryStore.swift` |
| APP-SCR-010 | macOS app | Inspector Share tab | Shows email invite form, role picker, feedback, empty state/list, compose, and remove actions. | Invalid email; duplicate email; persisted invites; no workspace; remove last invite. | `ShareView.swift`, `WorkspaceStore.addInvite()` |
| APP-SCR-011 | macOS app | Inspector Agents tab | Shows agent-safe editing explanation, agent rows, and CLI sync contract. | Agent status updates after external changes. | `InspectorView.swift`, `WorkspaceStore.agents` |
| APP-SCR-012 | macOS app | Settings window | Shows autosave toggle, font-size stepper, external-change toggle, and read-only folder labels. | Min/max font size; toggles during active edit. | `SettingsView.swift`, `GraftApp.swift` |
| APP-SCR-013 | Native dialogs | Open workspace panel | Directory-only picker opens selected folder. | Cancel; non-Markdown folder; hidden sidecars. | `WorkspaceStore.openWorkspacePanel()` |
| APP-SCR-014 | Native dialogs | Insert image panel | File picker accepts common image types and appends relative Markdown. | Nested doc; duplicate filename timestamp; unsupported file; canceled picker. | `WorkspaceStore.insertImageFromPanel()`, `ImageImportService.swift` |
| APP-SCR-015 | Native apps | Mail compose handoff | Compose action opens `mailto:` with sanitized invite body but does not send. | Missing workspace; URL encoding; no mail client. | `WorkspaceStore.composeEmail()` |
| APP-SCR-016 | macOS app | Review rail | Shows pending agent edits, file context, selected review state, conflict badges, and focus buttons. | No pending edits; pending review; conflict review; selected file differs from review file. | `ReviewRailView.swift`, `WorkspaceStore.pendingChangeSets` |
| APP-SCR-017 | macOS app | Inline diff panel | Shows review summary, current/proposed blocks, hunk metadata, Reject all, Accept all, Reject hunk, and Accept hunk controls. | Stale hunk; inserted/deleted block; multi-hunk packet; accepted/rejected last hunk. | `InlineDiffView.swift`, `WorkspaceStore.accept/reject` |
| APP-SCR-018 | macOS app | Conflict resolution panel | Shows human draft beside agent proposal with Keep draft and Use proposal controls. | Dirty local draft; conflict status; empty block. | `ConflictResolutionView.swift` |
| CLI-ROUTE-001 | CLI | `pagepacket-cli` usage route | Missing/unknown command prints usage. | No command; unknown command. | `Sources/GraftCLI/main.swift` |
| CLI-ROUTE-002 | CLI | `status <vault>` | Prints vault path, Markdown count, sidecar path, and first 12 relative files. | Missing path; 366-file fixture; hidden sidecars; `/tmp` normalization. | `Sources/GraftCLI/main.swift` |
| CLI-ROUTE-003 | CLI | `snapshot <vault> <file> --message ...` | Writes sidecar snapshot with front matter and current file content. | Missing args; file with spaces; nested file; unreadable file. | `Sources/GraftCLI/main.swift` |
| CLI-ROUTE-004 | CLI | `apply <vault> <file> --author ...` | Writes sidecar snapshot with applied-external-edit reason and author source. | Missing author; nested file; path-collision file. | `Sources/GraftCLI/main.swift` |
| CLI-ROUTE-005 | CLI | `history <vault> <file>` | Lists snapshots newest-first and supports legacy folder lookup. | No snapshots; colliding paths; spaces. | `Sources/GraftCLI/main.swift` |
| WEB-ROUTE-001 | Landing page | Vite root `/` and `#top` hero | Shows Pagepacket hero, terminal preview, hero waitlist form, and masthead join command. | Dev route; production build; favicon request; mobile width; reduced motion. | `landing page/index.html`, `landing page/src/App.jsx` |
| WEB-ROUTE-002 | Landing page | `#agents` | Shows the invisible-agent-edits problem section. | Anchor navigation; animated terminal stream. | `landing page/src/App.jsx` |
| WEB-ROUTE-003 | Landing page | `#workflow` | Shows four workflow decisions and terminal commands using `pagepacket-cli`. | Anchor navigation; copy must match actual product scope. | `landing page/src/App.jsx`, `Sources/GraftCLI/main.swift` |
| WEB-ROUTE-004 | Landing page | `#files` | Shows plain Markdown plus `.pagepacket/history` and `.pagepacket/reviews` sidecar explanation. | Copy drift from app/CLI sidecar paths. | `landing page/src/App.jsx`, `Sources/GraftCore/Review/ChangeSetStore.swift` |
| WEB-ROUTE-005 | Landing page | `#waitlist` | Shows waitlist form and stores a deduped local preview email in `localStorage`. | Invalid email; duplicate; corrupted localStorage; loading/success/error state. | `landing page/src/App.jsx` |
| WEB-ROUTE-006 | Landing page | Footer | Shows Pagepacket preview, local-first positioning, and product boundary copy. | Mobile wrapping; visible old-name drift. | `landing page/src/App.jsx` |

No backend waitlist route exists in this repo. The landing page is a Vite app, not a repo-root static HTML route.

## Buttons, Inputs, Modals, And States

| ID | Category | Inventory | Acceptance criteria | Finite edge cases | Source evidence |
| --- | --- | --- | --- | --- | --- |
| CTRL-001 | App toolbar | Open Workspace, mode segmented picker, Save, Snapshot, Insert Image, Inspector. | Each control is wired to the corresponding `WorkspaceStore` action/state. | No workspace; selected file missing; canceled modal; inspector toggle. | `ContentView.swift` |
| CTRL-002 | Editor header | Image and Save buttons. | Image opens insert flow; Save persists current document. | Nested doc image; save failure; empty file. | `MarkdownEditorView.swift` |
| CTRL-003 | Empty state | Open Workspace button. | Opens directory picker. | Cancel; directory without `.md` files. | `EditorContainerView.swift` |
| CTRL-004 | External banner | Accept, Reject, dismiss xmark. | Accept applies the selected review packet; Reject marks it rejected and restores visible draft; dismiss hides banner. | Dirty conflict; stale hunk; write failure; no selected review. | `ContentView.swift`, `WorkspaceStore.swift` |
| CTRL-005 | History | Plus checkpoint button and Restore button per snapshot. | Plus writes snapshot; Restore writes selected snapshot body to disk. | No selected file; malformed front matter; multiple snapshots. | `HistoryView.swift`, `VersionHistoryStore.swift` |
| CTRL-006 | Share | Email text field, role segmented picker, Add Invite, compose envelope, remove xmark. | Valid unique invite persists; invalid/duplicate shows feedback; remove updates manifest; compose opens mailto only. | Case/whitespace duplicates; invalid email; no workspace; no mail send. | `ShareView.swift`, `WorkspaceStore.swift` |
| CTRL-007 | Inspector | History/Share/Agents segmented picker. | Selected tab switches panel content. | Empty data in each tab. | `InspectorView.swift` |
| CTRL-008 | Settings | Autosave toggle, editor font-size stepper, external-change toggle. | State binds to `WorkspaceStore`; font size remains 12...24. | Toggle while dirty; boundary values 12 and 24. | `SettingsView.swift` |
| CTRL-009 | App menus | About, Settings, Quit, Open Workspace, Save Document, Snapshot Version, Undo/Redo/Cut/Copy/Paste/Select All, Edit/Split/Preview, Toggle Inspector. | Active menu actions target app/store or standard text selectors. | Menu state updates for selected mode/inspector. | `GraftApp.swift` |
| CTRL-010 | Landing nav/footer | Masthead terminal join link and footer colophon. | Join link resolves to `#waitlist`; footer remains Pagepacket-scoped. | Mobile width; animated scroll. | `landing page/src/App.jsx` |
| CTRL-011 | Landing waitlist | Shared hero/footer email state, email input, and submit button. | Invalid email sets error; valid local preview stores deduped email and shows success; corrupted storage recovers. | Corrupted localStorage; duplicate; loading state; mobile width. | `landing page/src/App.jsx` |
| CTRL-012 | Landing static proof | Terminal streams, workflow stages, and file ledger are presentational, not buttons. | No user-facing no-op product buttons are present. | Copy drift from actual CLI/sidecar vocabulary. | `landing page/src/App.jsx` |
| CTRL-013 | Review rail | Review row buttons. | Selecting a row focuses the matching file/review and marks it selected. | Review file not in current file list; conflict row; empty queue. | `ReviewRailView.swift`, `WorkspaceStore.focus()` |
| CTRL-014 | Inline review | Reject all, Accept all, Reject hunk, Accept hunk, Keep draft, Use proposal. | All controls either move review metadata to final status or update remaining hunk state while preserving a snapshot. | Stale hunk; final remaining hunk; conflict range; write failure. | `InlineDiffView.swift`, `ConflictResolutionView.swift`, `WorkspaceStore.swift` |

Primary app states found: no workspace, workspace loaded, no selected file, selected file loaded, saved, unsaved, autosave enabled/disabled, inspector hidden/visible, history empty/populated, invite list empty/populated, invite feedback invalid/duplicate, external change reloaded/conflict/dismissed, external-change detection enabled/disabled, app launched/reopened, CLI usage/success/error, landing waitlist idle/loading/error/success.

## Workflows

| ID | Workflow | Acceptance criteria | Finite edge cases | Source evidence |
| --- | --- | --- | --- | --- |
| WF-001 | Open a local workspace | Opening a generated fixture creates sidecars, lists 366 visible Markdown files, selects the first sorted file, and excludes `.pagepacket`/`.graft` Markdown. | Empty folder; nested files; hidden sidecars; filename spaces. | `WorkspaceStore.openWorkspace()`, fixture manifest |
| WF-002 | Edit and save Markdown | Editing changes dirty state; save snapshots previous disk text, writes editor text, marks clean, and refreshes snapshots. | Empty file; long line; save failure. | `WorkspaceStore.saveCurrentDocument()` |
| WF-003 | Preview Markdown | Preview reflects renderer output for supported Markdown block types and missing image state. | Repeated blocks; ordered numbering; code fence EOF; missing image. | `MarkdownRenderer.swift`, `MarkdownPreviewView.swift` |
| WF-004 | Import local image | Image copy lands under workspace `assets/<document>/` and inserted Markdown is relative to selected document. | Nested document; timestamp collision; unsupported extension. | `ImageImportService.swift` |
| WF-005 | Snapshot and restore | Manual/save/CLI snapshots write front matter sidecars; restore strips front matter and writes original body. | Legacy history folder; path-collision files; malformed snapshot. | `VersionHistoryStore.swift`, CLI |
| WF-006 | Resolve external edits | File watcher detects disk edits, creates a local review packet, restores the human draft to disk, and lets the user accept/reject the packet before it becomes canonical. | Detection disabled; deleted file; clean selected file; dirty selected file conflict; nonselected file. | `FileWatcher.swift`, `WorkspaceStore.handleExternalChange()`, `ChangeSetStore.swift` |
| WF-007 | Add/share invite intent | Valid unique invite persists with role; compose opens mailto draft; remove deletes intent. | Invalid email; duplicate; no workspace; no real send. | `ShareView.swift`, `WorkspaceStore.swift` |
| WF-008 | Agent CLI sync | Agent checks status, snapshots before edit, applies checkpoint after edit, and views history. | Missing args; nested file; path normalization; hidden sidecars. | `Sources/GraftCLI/main.swift`, `skills/graft-sync/SKILL.md` |
| WF-009 | Landing waitlist | Visitor can navigate sections and submit a valid email to local preview storage without backend. | Invalid email; duplicate; corrupted localStorage; custom endpoint error. | `landing page/index.html`, `script.js` |
| WF-010 | Build/run/verify | Developer can build SwiftPM package, run regression checks, smoke CLI, verify launched app process, and run whitespace check. | Isolated build path; local XCTest unavailable; LaunchServices quirks. | `Package.swift`, scripts, tests |
