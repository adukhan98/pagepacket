# Graft Ship Readiness

Date: 2026-06-20
Branch: `codex/graft-agent-review-loop`

## Current Git State

- `git diff --cached --name-only` reports only `design.md`.
- `git status --short` shows `RM DESIGN.md -> design.md`, which means `design.md` is already staged as a rename from `DESIGN.md` and also has unstaged edits.
- Do not unstage, rename, revert, or otherwise alter `design.md` without explicit user approval.
- This checklist file is intentionally untracked and should remain unstaged until the release scope is confirmed.

## Dirty Item Classification

### App Release

- `Package.swift`
- `SampleVault/AGENTS.md`
- `SampleVault/welcome.md`
- `Sources/Graft/App/GraftApp.swift`
- `Sources/Graft/App/GraftCommands.swift`
- `Sources/Graft/Models/MarkdownBlock.swift`
- `Sources/Graft/Models/EditorSelection.swift`
- `Sources/Graft/Services/ImageImportService.swift`
- `Sources/Graft/Services/MarkdownRenderer.swift`
- `Sources/Graft/Services/MarkdownSyntaxHighlighter.swift`
- `Sources/Graft/Stores/WorkspaceStore.swift`
- `Sources/Graft/Views/ContentView.swift`
- `Sources/Graft/Views/EditorContainerView.swift`
- `Sources/Graft/Views/HistoryView.swift`
- `Sources/Graft/Views/InspectorView.swift`
- `Sources/Graft/Views/MarkdownEditorView.swift`
- `Sources/Graft/Views/MarkdownPreviewView.swift`
- `Sources/Graft/Views/ShareView.swift`
- `Sources/Graft/Views/SidebarView.swift`
- `Sources/Graft/Views/Theme.swift`
- `Sources/Graft/Views/ConflictResolutionView.swift`
- `Sources/Graft/Views/InlineDiffView.swift`
- `Sources/Graft/Views/MarkdownTextView.swift`
- `Sources/Graft/Views/ReviewRailView.swift`
- `Sources/GraftCore/`
- `Sources/GraftCLI/main.swift`
- `Tests/`
- `skills/graft-sync/SKILL.md`

### Docs / Design

- `README.md`
- `design.md`
- `docs/reference/`
- `docs/superpowers/plans/2026-06-16-graft-markdown-editor.md`
- `docs/superpowers/plans/2026-06-20-graft-agent-review-loop.md`
- `docs/superpowers/plans/2026-06-20-graft-document-review-surface-v2.md`

### Landing Page

- `landing page/`

This includes source, public assets, package files, generated `dist/`, Playwright QA screenshots, and local test output. Split source and generated artifacts before including this in any release commit.

### Launch Video

- `launch-video/`

This includes HyperFrames source/config, assets, rendered MP4s, thumbnails, and reference images. Treat as a separate launch-asset package unless the release explicitly includes video deliverables.

### Generated QA / Runtime Artifacts

- `.hallmark/`
- `.playwright-mcp/`
- `landing page/dist/`
- `landing page/node_modules/`
- `landing page/qa/`
- `landing page/test-results/`
- `launch-video/graft-coming-soon/.thumbnails/`
- `launch-video/graft-coming-soon/renders/`

### Unknown / Needs Owner Decision

- `product_brief.md`

## Release-Scope Recommendation

Ship the app release as the primary scope for this branch: Swift package changes, app views/services/models, `GraftCore`, CLI changes, tests, sample vault updates, and the sync skill.

Keep the landing page and launch video out of the app release commit unless the intended release is a combined launch bundle. They have separate dependency graphs, generated artifacts, and QA outputs, so they should be reviewed and packaged independently.

Keep docs/design changes only when they directly explain the app release. Resolve the `design.md` staging state explicitly before any commit because it is already staged and has unstaged edits.

## Known Blockers

- Confirm whether the release is app-only or a combined app plus launch-surfaces release.
- Resolve `design.md` staging ownership. It is already staged and should not be unstaged without user approval.
- Decide whether `product_brief.md` belongs in docs/design scope or should remain local.
- Separate generated/runtime artifacts from source before staging any landing page or launch video work.
- Run `swift test` on a full Xcode toolchain. The current local environment fails before tests run because `XCTest` cannot be imported.
- Sign and notarize before public macOS distribution. The current generated bundle is ad hoc signed and fails Gatekeeper assessment.

## Audit Fixes Applied

- Review persistence now has to succeed before Graft restores the local draft over an external file edit.
- Replacing an existing pending/conflict review now writes the new review before deleting superseded reviews.
- Whole-review accept applies only the remaining review hunks instead of blindly replacing the document with the original full proposal.
- Hunk accept now refuses to patch if the visible draft has drifted from the review base.
- Switching files now saves dirty Markdown before loading the next file.
- Packaging now has `script/package_release.sh`, and `script/build_and_run.sh` supports `GRAFT_BUILD_PATH` so release packaging can use an isolated SwiftPM build directory.

## Latest Verification

- `swift build --build-path /tmp/graft-ship-build`: passed.
- `swift test --build-path /tmp/graft-ship-test --filter MarkdownPatchEngineTests`: blocked by `no such module 'XCTest'`.
- `./script/package_release.sh`: passed and produced `dist/Graft.zip`.
- `codesign -dvvv --entitlements :- dist/Graft.app`: ad hoc signature, no team identifier, no sealed resources.
- `spctl -a -vv dist/Graft.app`: failed with `code has no resources but signature indicates they must be present`.
- App verification generated `SampleVault/AGENTS.md`; it was removed after verification.

## Verification Commands

Run from the repo root unless noted.

```bash
git status --short
git diff --cached --name-only
swift build
swift test
./script/build_and_run.sh --verify
```

For the landing page, only if it is included in release scope:

```bash
cd "landing page"
npm run build
npx playwright test qa/responsive.spec.js
npm audit --audit-level=high
```

For the launch video, only if it is included in release scope:

```bash
cd "launch-video/graft-coming-soon"
npm run check
npm run render
ls -lh renders/*.mp4
```

## Shipping Checklist

- [ ] App release scope is confirmed.
- [ ] `design.md` staged rename and unstaged edits are intentionally handled with user approval.
- [ ] Unknown file ownership is resolved for `product_brief.md`.
- [ ] Generated QA/runtime artifacts are excluded or intentionally packaged.
- [ ] `swift build` passes.
- [ ] `swift test` passes on a full Xcode toolchain.
- [ ] `./script/build_and_run.sh --verify` launches `dist/Graft.app`.
- [ ] `./script/package_release.sh` produces `dist/Graft.zip`.
- [ ] Developer ID signing and notarization pass for public distribution.
- [ ] Landing page verification passes if landing page is in scope.
- [ ] Launch video verification passes if launch video is in scope.
- [ ] Final `git status --short` is reviewed before staging anything.
