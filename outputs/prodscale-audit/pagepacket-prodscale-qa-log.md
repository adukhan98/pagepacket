# Pagepacket Production-Scale QA Log

Run date: 2026-07-06

Fixture: `outputs/prodscale-fixtures/pagepacket-prodscale-vault`

## Evidence Summary

| Check | Result | Evidence |
| --- | --- | --- |
| Fixture generation | Pass | `node outputs/prodscale-fixtures/generate_prodscale_fixture.mjs` generated 366 visible Markdown files plus 2 hidden sidecar Markdown files. |
| Independent fixture count | Pass | `find ... -not -path '*/.pagepacket/*' -not -path '*/.graft/*' -name '*.md' | wc -l` returned `366`. |
| Swift isolated build | Pass | `swift build --jobs 1 --build-path /tmp/pagepacket-prodscale-build` exited 0. |
| App regression runner | Pass | `./Tests/run_regression_checks.sh` printed `regression checks passed`. |
| Review-packet behavior harness | Pass | `/tmp/pagepacket-prodscale-build/debug/pagepacket-behavior-harness` passed 8 checks. |
| SwiftPM XCTest suite | Toolchain blocked | `swift test --jobs 1 --build-path /tmp/pagepacket-prodscale-test` failed with `no such module 'XCTest'`; local custom runner and behavior harness were used instead. |
| CLI production-scale QA | Pass | `run_prodscale_checks.mjs` verified 366-file status, hidden sidecar exclusion, and outside-vault snapshot refusal. |
| macOS app launch | Pass | `./script/build_and_run.sh --verify` exited 0; CoreGraphics reported an onscreen `Pagepacket` window at `1120x772`. |
| Landing Vite QA | Pass | `run_prodscale_checks.mjs` verified favicon, Pagepacket vocabulary, primary sections, corrupted-storage recovery, and mobile overflow. |
| Landing production build | Pass | `npm run build` in `landing page/` exited 0. |

## Final Rerun

After the inventory and review-flow documentation were updated, the local rerun passed:

```bash
./Tests/run_regression_checks.sh
PAGEPACKET_CLI=/tmp/pagepacket-prodscale-build/debug/pagepacket-cli PAGEPACKET_LANDING_BASE_URL=http://127.0.0.1:8766 node outputs/prodscale-audit/run_prodscale_checks.mjs
git diff --check
```

The temporary Vite and Python servers were stopped after verification. The Pagepacket app process launched for `./script/build_and_run.sh --verify` was also stopped.

## Bugs Logged And Fixed

| ID | Area | Bug | Reproduction evidence | Shared cause | Fix | Regression evidence |
| --- | --- | --- | --- | --- | --- | --- |
| BUG-001 | Swift app/package | Unresolved merge conflict artifacts were present in app source, including duplicate ` 2.swift` files. | `./Tests/run_regression_checks.sh` failed with source-control conflict marker errors. | Rename/review-packet merge drift between older Pagepacket code and newer review-packet code. | Resolved files toward Pagepacket + `GraftCore`, deleted duplicate conflict artifacts, kept `.pagepacket` sidecars. | `rg '<<<<<<<|=======|>>>>>>>' Package.swift Sources Tests` found no markers; Swift build and regression runner pass. |
| BUG-002 | Regression harness | `Tests/run_regression_checks.sh` could not compile `WorkspaceStore` after the package split because `GraftCore` was not built for the direct `swiftc` path. | Runner failed before executing checks. | Test harness drift from source layout. | Build `GraftCore` as a local dynamic module first and link it into the regression binary. | `./Tests/run_regression_checks.sh` passes. |
| BUG-003 | App workspace state | Opening a workspace with no Markdown files could retain stale selected-document text, snapshots, or banners. | New regression `testOpeningWorkspaceWithNoMarkdownClearsSelectedDocumentState`. | Missing explicit empty-workspace reset path. | `openWorkspace(_:)` now calls `clearDocumentState()` when no file is selected. | Regression runner passes. |
| BUG-004 | CLI safety | CLI snapshot/apply/history accepted paths outside the selected vault. | Production QA attempts `snapshot <vault> ../outside-vault-file.md`. | CLI normalized paths but did not enforce vault containment. | Added `isInside(_:vault:)` guard and nonzero refusal for outside-vault paths. | `CLI-PROD-003` passes. |
| BUG-005 | Landing route/copy | Landing app was Vite-based but QA targeted the old static route; visible copy still used Graft/`.graft` vocabulary. | Browser QA timed out on old `#cli`; direct HTML inspection showed Vite shell and Graft copy. | Artifact drift between old static landing page and current Vite app. | QA now targets Vite root; visible copy now uses Pagepacket, `pagepacket-cli`, and `.pagepacket`. | `WEB-PROD-002` and `npm run build` pass. |
| BUG-006 | Landing waitlist | Waitlist success did not persist local preview emails or recover corrupted storage. | New browser QA seeds malformed `pagepacket-waitlist-preview` before submission. | Local preview branch was missing from the React rewrite. | Added `saveWaitlistEmail()` with parse recovery and deduped normalized emails. | `WEB-PROD-004` passes. |
| BUG-007 | macOS app launch | Packaged app launched a process but Accessibility reported zero windows after the SwiftUI lifecycle merge. | `./script/build_and_run.sh --verify` exited 0 but window probing returned no accessible windows; CoreGraphics direct probe was used to confirm after the fix. | App lifecycle drift from the hand-staged `.app` bundle path. | Restored explicit AppKit `NSWindow` creation while keeping the review-packet content view. | `./script/build_and_run.sh --verify` exits 0 and CoreGraphics reports an onscreen `1120x772` Pagepacket window. |

## Shared Causes

The fixes cluster around two shared causes:

1. Product rename drift: parts of the repo still used Graft names, `.graft` sidecars, and old CLI command copy while the app/package had moved to Pagepacket.
2. Artifact drift: the app gained `GraftCore` review-packet code and the landing page moved to Vite, but test scripts and inventory still assumed the older single-target/static-page shape.

## Rerun Checklist

Run these before claiming a clean pass:

```bash
node outputs/prodscale-fixtures/generate_prodscale_fixture.mjs
swift build --jobs 1 --build-path /tmp/pagepacket-prodscale-build
swift build --product pagepacket-cli --jobs 1 --build-path /tmp/pagepacket-prodscale-build
./Tests/run_regression_checks.sh
PAGEPACKET_CLI=/tmp/pagepacket-prodscale-build/debug/pagepacket-cli PAGEPACKET_LANDING_BASE_URL=http://127.0.0.1:8766 node outputs/prodscale-audit/run_prodscale_checks.mjs
(cd "landing page" && npm run build)
./script/build_and_run.sh --verify
git diff --check
```
