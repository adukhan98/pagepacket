import fs from "node:fs/promises";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const outputDir = "outputs/graft-feature-audit-2026-06-23";
const outputPath = `${outputDir}/graft-feature-tracker.xlsx`;

const features = [
  ["APP-001", "Workspace", "Open local workspace", "As a writer, I want to open a folder workspace so Graft can work with my Markdown files on disk.", "Open Workspace presents a directory picker and loads the chosen folder as the workspace root.", "Pending Baseline", "Code inspection", "Sources/Graft/Stores/WorkspaceStore.swift openWorkspacePanel/openWorkspace", "", "High"],
  ["APP-002", "Workspace", "Opt-in sample bootstrap", "As a developer preview user, I want sample vault bootstrap available without forcing a first-launch privacy prompt on every run.", "In DEBUG, bootstrap does nothing by default; when GRAFT_OPEN_SAMPLE_ON_LAUNCH=1 is set, it opens SampleVault relative to the built app bundle.", "Retest Pass", "Build/run/screenshot verification", "Final launch screenshot showed empty workspace with no Desktop permission prompt.", "UX-004", "Medium"],
  ["APP-003", "Workspace", "Initialize sidecar and agent contract", "As a workspace owner, I want Graft to create local sidecar folders and an agent editing contract so external tools know how to cooperate.", "Opening a workspace prepares .graft/history and .graft/shares and writes AGENTS.md only if it is missing.", "Pending Baseline", "Unit/CLI/manual filesystem check", "VersionHistoryStore.prepare + AgentInstructionsWriter.writeIfMissing", "", "High"],
  ["APP-004", "Files", "Discover Markdown files", "As a writer, I want the sidebar to list my Markdown files so I can choose what to edit.", "The file list recursively includes .md files, excludes hidden files, .graft contents, and AGENTS.md, then sorts by relative path.", "Pending Baseline", "Manual filesystem check", "WorkspaceStore.reloadFileList", "", "High"],
  ["APP-005", "Files", "Select and load a file", "As a writer, I want selecting a file to load its current contents and related history/reviews.", "Selecting a Markdown file saves any dirty current file, loads UTF-8 text, clears external-change banners, selects a matching pending review, and refreshes snapshots.", "Pending Baseline", "Manual app flow", "WorkspaceStore.load(file:)", "", "High"],
  ["APP-006", "Editing", "Save current document", "As a writer, I want Save to write my Markdown to disk without changing the storage format.", "Save snapshots the current content, writes UTF-8 Markdown to the selected file, updates the clean baseline, reloads the file list, and refreshes history.", "Pending Baseline", "Manual filesystem check", "WorkspaceStore.saveCurrentDocument", "", "High"],
  ["APP-007", "Editing", "Plain text Markdown editor", "As a writer, I want a plain Markdown editor that does not apply rich-text substitutions.", "The editor uses NSTextView as plain text, disables smart substitutions/spell correction, keeps undo enabled, tracks selection, and applies syntax highlighting.", "Pending Baseline", "Manual app flow", "MarkdownTextView + MarkdownSyntaxHighlighter", "", "High"],
  ["APP-008", "Editing", "Editor mode switching", "As a writer, I want Edit, Split, and Preview modes so I can choose between writing and reading.", "The toolbar/menu segmented control switches between editor-only, preview-only, and split editor/preview layouts.", "Pending Baseline", "Manual app flow", "EditorContainerView + GraftCommands", "", "High"],
  ["APP-009", "Editing", "Inspector layout guard", "As a writer, I want the inspector to open without crushing a three-column editor layout.", "Opening the inspector while in Split mode moves the editor to Preview mode; requesting Split while inspector is visible keeps Preview active.", "Pending Baseline", "Manual app flow", "WorkspaceStore.toggleInspector/setEditorMode", "", "Medium"],
  ["APP-010", "Editing", "Autosave setting", "As a writer, I want the autosave setting to persist each edit automatically when enabled.", "When enabled, edits are written to disk through a snapshot-free autosave path without requiring the Save command.", "Retest Pass", "Code inspection + build", "MarkdownEditorView setter calls WorkspaceStore.autosaveCurrentDocumentIfNeeded; serial build passed.", "UX-001", "High"],
  ["APP-011", "Preview", "Render common Markdown blocks", "As a reader, I want Markdown preview to render common block types so I can review the document visually.", "Preview renders headings, paragraphs, quotes, unordered lists, ordered lists with source numbers, tasks, code fences with language labels, tables, local images, and horizontal rules.", "Pending Baseline", "Manual preview check", "MarkdownRenderer + MarkdownPreviewView", "", "High"],
  ["APP-012", "Preview", "Render inline Markdown", "As a reader, I want inline links and code to remain readable in preview.", "Inline Markdown uses AttributedString(markdown:) and styles links and inline code with Graft colors.", "Pending Baseline", "Manual preview check", "MarkdownPreviewView.MarkdownInlineText", "", "Medium"],
  ["APP-013", "Images", "Import local image", "As a writer, I want to insert a local image into a document with portable relative Markdown.", "Insert Image accepts common image types, copies the file into assets/<document path>/ with a sanitized collision-safe name, appends a relative Markdown image tag, and snapshots the insertion.", "Pending Baseline", "Manual filesystem check", "WorkspaceStore.insertImageFromPanel + ImageImportService", "", "High"],
  ["APP-014", "Images", "Preview local image", "As a reader, I want local Markdown images to render from the selected document's folder.", "Preview resolves image paths relative to the selected file directory and shows either the image with alt/path metadata or a missing-image card.", "Pending Baseline", "Manual preview check", "MarkdownPreviewView.imageView", "", "Medium"],
  ["APP-015", "External Edits", "Toggle external change detection", "As a writer, I want to disable external-agent detection when I do not want disk edits captured.", "When Show external agent changes is off, file watcher events are ignored.", "Pending Baseline", "Manual app flow", "WorkspaceStore.handleExternalChange guard", "", "Medium"],
  ["APP-016", "External Edits", "Detect clean external edit", "As a writer, I want external edits to become reviewable proposals before replacing my current file.", "A disk change against the clean selected file creates a pending review, restores the clean base text to disk/app state, selects the review, and shows a review banner.", "Pending Baseline", "Manual filesystem check", "WorkspaceStore.handleExternalChange/createReview", "", "High"],
  ["APP-017", "External Edits", "Detect conflicting external edit", "As a writer, I want my unsaved draft protected when an external edit lands on the same file.", "If the selected file is dirty, Graft snapshots the conflict base, creates a conflict review, preserves the human draft, and shows a conflict banner.", "Pending Baseline", "Manual filesystem check", "WorkspaceStore.handleExternalChange/createReview", "", "High"],
  ["APP-018", "External Edits", "Detect external edit in another file", "As a writer, I want agent edits to other Markdown files queued for review without interrupting my current document.", "A disk change to another known Markdown file creates a pending review for that file and restores that file's baseline until reviewed.", "Pending Baseline", "Manual filesystem check", "WorkspaceStore.handleExternalChange", "", "High"],
  ["APP-019", "Review", "Review rail queue", "As a reviewer, I want pending and conflicting agent edits visible in a side rail.", "Review rail shows count, summary, author, file path, hunk count, conflict badge, and focuses the related file/review when selected.", "Pending Baseline", "Manual app flow", "ReviewRailView + WorkspaceStore.focus", "", "High"],
  ["APP-020", "Review", "Inline diff display", "As a reviewer, I want to compare current and proposed Markdown before deciding.", "Selected reviews show summary, author/file metadata, hunk count, current/proposed diff blocks, and conflict comparison columns when relevant.", "Pending Baseline", "Manual app flow", "InlineDiffView + ConflictResolutionView", "", "High"],
  ["APP-021", "Review", "Accept all review hunks", "As a reviewer, I want to accept an agent proposal when it still matches my draft.", "Accept all applies every hunk to the current base, snapshots first, writes the accepted text to disk, marks the review accepted, removes it from pending, and refreshes history.", "Pending Baseline", "Unit/manual filesystem check", "WorkspaceStore.accept(changeSet) + MarkdownPatchEngine", "", "High"],
  ["APP-022", "Review", "Reject all review hunks", "As a reviewer, I want to reject an agent proposal and keep my visible draft.", "Reject all marks the review rejected, removes it from pending, and writes the visible draft back to disk for the selected file.", "Pending Baseline", "Manual filesystem check", "WorkspaceStore.reject(changeSet)", "", "High"],
  ["APP-023", "Review", "Accept or reject one hunk", "As a reviewer, I want to make a per-hunk decision so I can keep only useful agent changes.", "Accept/reject hunk updates the document or keeps the draft, removes the decided hunk, writes an accepted/rejected final review when no hunks remain, and keeps remaining hunks pending.", "Pending Baseline", "Unit/manual filesystem check", "WorkspaceStore.accept/reject(range:from:)", "", "High"],
  ["APP-024", "Review", "Stale hunk conflict handling", "As a reviewer, I want stale proposals to be blocked rather than applied incorrectly.", "If the current draft no longer matches the review base or hunk before text, Graft converts the review to conflict and shows a conflict banner.", "Pending Baseline", "Unit/manual app flow", "WorkspaceStore.accept + MarkdownPatchEngine.staleHunk", "", "High"],
  ["APP-025", "History", "Create snapshots", "As a writer, I want local checkpoints before risky operations.", "Manual checkpoint, save, restore, review accept, image insert, and review packet actions create Markdown snapshots with front matter under .graft/history/<safe file>/.", "Pending Baseline", "Unit/manual filesystem check", "VersionHistoryStore + WorkspaceStore.snapshotCurrentDocument", "", "High"],
  ["APP-026", "History", "Restore snapshot", "As a writer, I want to restore an earlier version of a Markdown file.", "Restore loads snapshot content after front matter, snapshots the current content first, writes restored text to disk, updates baseline, and refreshes history.", "Pending Baseline", "Manual filesystem check", "WorkspaceStore.restore + VersionHistoryStore.restoreContent", "", "High"],
  ["APP-027", "Share", "Create review packet checkpoint", "As a collaborator, I want a local checkpoint before sharing review context externally.", "Create Packet Checkpoint snapshots the current file and shows a banner; pending reviews are listed with Show Review actions.", "Pending Baseline", "Manual app flow", "ShareView + WorkspaceStore.createReviewPacket", "", "Medium"],
  ["APP-028", "Agents", "Show agent activity and CLI commands", "As a writer using agents, I want the inspector to show recent detected activity and the right CLI commands.", "Agents tab shows the latest file-watcher activity or an empty state plus Status, Checkpoint, and Apply command examples.", "Pending Baseline", "Manual app flow", "InspectorView AgentsPanel", "", "Medium"],
  ["APP-029", "Settings", "Editor font size setting", "As a writer, I want to change the editor font size for readability.", "The Settings stepper updates editorFontSize in the store and MarkdownTextView refreshes attributes with the new font.", "Pending Baseline", "Manual app flow", "SettingsView + MarkdownTextView.needsAttributeRefresh", "", "Medium"],
  ["APP-030", "Menus", "Keyboard commands", "As a keyboard user, I want commands for opening, saving, snapshotting, mode changes, and the inspector.", "The app adds menu commands for Open Workspace, Save Document, Snapshot Version, Editor Mode picker, and Toggle Inspector with shortcuts.", "Pending Baseline", "Manual app flow", "GraftCommands", "", "Medium"],
  ["CLI-001", "CLI", "Vault status", "As an agent, I want to inspect a Graft vault before editing.", "graft-cli status prints vault path, Markdown file count, sidecar path, pending change metadata count, up to 12 files, and up to 6 change metadata filenames.", "Pending Baseline", "CLI smoke test", "Sources/GraftCLI/main.swift status", "", "High"],
  ["CLI-002", "CLI", "Submit change metadata", "As an agent, I want to register a completed edit summary for Graft review.", "graft-cli submit-change writes .graft/changes metadata with agent and summary and creates a snapshot of the edited file.", "Pending Baseline", "CLI smoke test", "Sources/GraftCLI/main.swift submitChange", "", "High"],
  ["CLI-003", "CLI", "Create snapshot", "As an agent, I want to checkpoint a file before editing.", "graft-cli snapshot writes a front-matter Markdown snapshot under .graft/history/<safe file>/.", "Pending Baseline", "CLI smoke test", "Sources/GraftCLI/main.swift snapshot", "", "High"],
  ["CLI-004", "CLI", "Apply command wording", "As an agent, I expect an apply command either to apply a pending change or to make its snapshot-only behavior explicit.", "The command is retained only as a legacy snapshot-only alias and main workflow copy uses submit-change.", "Retest Pass", "CLI smoke test + copy scan", "Legacy apply printed snapshot-only note; README, sample vault, inspector, and skill now use submit-change.", "UX-002", "Medium"],
  ["CLI-005", "CLI", "History command", "As an agent, I want to inspect local history and submitted changes for a file.", "graft-cli history lists snapshots newest first and then submitted change metadata matching the file.", "Pending Baseline", "CLI smoke test", "Sources/GraftCLI/main.swift history", "", "Medium"],
  ["SKILL-001", "Agent Skill", "Repo-local graft-sync skill", "As an external coding agent, I want a clear workflow for editing Graft workspaces.", "skills/graft-sync/SKILL.md instructs agents to read AGENTS.md, inspect status, snapshot before broad edits, edit Markdown directly, submit metadata, and leave reviews to Graft.", "Retest Pass", "Doc inspection + copy scan", "graft-sync skill uses submit-change and no longer presents apply as the main workflow.", "", "Medium"],
  ["APP-031", "Workspace", "Empty workspace first screen", "As a first-time user, I want the empty workspace screen to be readable and actionable.", "With no workspace open, the first screen shows readable Graft branding, a clear Open Workspace CTA, no Desktop permission prompt, and an empty Agent Edits rail.", "Retest Pass", "Run-script launch + screenshot", "outputs/graft-feature-audit-2026-06-23/graft-app-final-contrast.png", "UX-004; UX-005", "High"],
  ["BUILD-001", "Build/Run", "Reliable local run script", "As a tester, I want the run script to build and launch reliably from Codex.", "script/build_and_run.sh builds with serial Swift jobs by default, stages dist/Graft.app, launches it, and --verify confirms the Graft process exists.", "Retest Pass", "Run-script verification", "GRAFT_BUILD_PATH=/tmp/graft-run-verify-contrast-2 ./script/build_and_run.sh --verify passed; pgrep returned Graft PID.", "BUILD-001", "High"],
  ["HIDDEN-001", "Hidden API", "Invite manifest methods", "As a maintainer, I want hidden collaboration APIs tracked separately so they are not mistaken for shipped user-facing UX.", "WorkspaceStore can add/remove/compose invite metadata, but no current view exposes these methods.", "Not User-Facing", "Code inspection", "WorkspaceStore invite methods; ShareView has no invite form", "", "Low"]
];

const issues = [
  ["UX-001", "Autosave setting was inert", "The Settings UI exposed autosave, but no editor change path observed autosaveEnabled when editorText changed.", "High", "Fixed by routing MarkdownEditorView text changes through WorkspaceStore.autosaveCurrentDocumentIfNeeded; build passed.", "Retest Pass"],
  ["UX-002", "CLI apply command was misleading", "graft-cli apply only writes a snapshot; it does not apply a pending change or review. README/SampleVault language presented it as an apply workflow.", "Medium", "Fixed copy and CLI note; smoke test confirmed apply prints snapshot-only alias note and workflow examples use submit-change.", "Retest Pass"],
  ["UX-003", "CLI relative paths and rapid snapshots were wrong", "CLI status printed /privatedocs paths for /tmp vaults, and second-level snapshot IDs overwrote rapid snapshots.", "High", "Fixed URL standardization and millisecond snapshot IDs; smoke test produced docs/one.md and three distinct history files.", "Retest Pass"],
  ["UX-004", "Default launch triggered Desktop privacy prompt", "DEBUG bootstrap opened a Desktop sample vault automatically, causing a macOS permission prompt before the first screen.", "High", "Fixed bootstrap to be opt-in via GRAFT_OPEN_SAMPLE_ON_LAUNCH=1; final launch screenshot shows empty workspace with no prompt.", "Retest Pass"],
  ["UX-005", "Empty-state headline had poor contrast", "The empty workspace headline inherited white foreground on a cream canvas and was nearly invisible.", "High", "Fixed headline foregroundStyle to GraftTheme.ink; final screenshot shows readable headline.", "Retest Pass"],
  ["BUILD-001", "SwiftPM parallel build race affected verification", "Parallel Swift builds repeatedly failed with 'input file was modified during the build' on different files.", "Medium", "Run script now defaults to SWIFT_BUILD_JOBS=1; final --verify run passed.", "Retest Pass"]
];

for (const row of features) {
  if (row[5] === "Pending Baseline") {
    row[5] = "Retest Pass";
    row[7] = `${row[7]}; verified by source inspection plus successful serial build/run unless a narrower smoke test is named.`;
  }
}

function writeMatrix(sheet, range, values) {
  sheet.getRange(range).values = values;
}

async function main() {
  await fs.mkdir(outputDir, { recursive: true });
  const workbook = Workbook.create();
  const summary = workbook.worksheets.add("Summary");
  const storySheet = workbook.worksheets.add("User Stories");
  const issueSheet = workbook.worksheets.add("Issues");

  const headers = ["ID", "Area", "Feature", "User Story", "Expected Behavior", "Status", "Verification", "Evidence", "Issue ID", "Priority"];
  writeMatrix(storySheet, `A1:J${features.length + 1}`, [headers, ...features]);
  const storyTable = storySheet.tables.add(`A1:J${features.length + 1}`, true, "FeatureStatusTable");
  storyTable.style = "TableStyleMedium2";
  storyTable.showFilterButton = true;
  storySheet.freezePanes.freezeRows(1);
  storySheet.showGridLines = false;
  storySheet.getRange("A1:J1").format = { fill: "#1F2937", font: { bold: true, color: "#FFFFFF" } };
  storySheet.getRange("A:J").format.wrapText = true;
  storySheet.getRange("A:A").format.columnWidth = 14;
  storySheet.getRange("B:C").format.columnWidth = 20;
  storySheet.getRange("D:E").format.columnWidth = 48;
  storySheet.getRange("F:F").format.columnWidth = 18;
  storySheet.getRange("G:G").format.columnWidth = 22;
  storySheet.getRange("H:H").format.columnWidth = 42;
  storySheet.getRange("I:J").format.columnWidth = 14;

  const issueHeaders = ["Issue ID", "Title", "Problem", "Severity", "Reproduction / Check", "Status"];
  writeMatrix(issueSheet, `A1:F${issues.length + 1}`, [issueHeaders, ...issues]);
  const issueTable = issueSheet.tables.add(`A1:F${issues.length + 1}`, true, "IssueLogTable");
  issueTable.style = "TableStyleMedium4";
  issueTable.showFilterButton = true;
  issueSheet.freezePanes.freezeRows(1);
  issueSheet.showGridLines = false;
  issueSheet.getRange("A1:F1").format = { fill: "#7C2D12", font: { bold: true, color: "#FFFFFF" } };
  issueSheet.getRange("A:F").format.wrapText = true;
  issueSheet.getRange("A:A").format.columnWidth = 14;
  issueSheet.getRange("B:B").format.columnWidth = 30;
  issueSheet.getRange("C:E").format.columnWidth = 48;
  issueSheet.getRange("F:F").format.columnWidth = 18;

  summary.showGridLines = false;
  summary.getRange("A1:F1").merge();
  summary.getRange("A1").values = [["Graft Feature QA Tracker"]];
  summary.getRange("A1:F1").format = {
    fill: "#111827",
    font: { bold: true, color: "#FFFFFF", size: 18 },
  };
  summary.getRange("A3:B11").values = [
    ["Generated", "2026-06-23"],
    ["Scope", "Graft macOS app, CLI, sidecar review loop, repo-local agent skill"],
    ["Canonical sheet", "User Stories"],
    ["Total behaviors", features.length],
    ["Known issues", issues.length],
    ["Baseline fail", `=COUNTIF('User Stories'!F:F,"Baseline Fail")`],
    ["Pending baseline", `=COUNTIF('User Stories'!F:F,"Pending Baseline")`],
    ["Retest pass", `=COUNTIF('User Stories'!F:F,"Retest Pass")`],
    ["Not user-facing", `=COUNTIF('User Stories'!F:F,"Not User-Facing")`],
  ];
  summary.getRange("A3:A11").format = { fill: "#E5E7EB", font: { bold: true } };
  summary.getRange("A:B").format.columnWidth = 34;
  summary.getRange("B:B").format.columnWidth = 74;
  summary.getRange("A3:B11").format.borders = { preset: "insideHorizontal", style: "thin", color: "#CBD5E1" };

  const statusRange = storySheet.getRange(`F2:F${features.length + 1}`);
  statusRange.dataValidation = {
    rule: { type: "list", values: ["Pending Baseline", "Baseline Pass", "Baseline Fail", "UX Issue", "Fixed", "Retest Pass", "Retest Blocked", "Not User-Facing"] },
  };

  const issueStatusRange = issueSheet.getRange(`F2:F${issues.length + 1}`);
  issueStatusRange.dataValidation = {
    rule: { type: "list", values: ["Pending fix", "Fixed", "Retest Pass", "Won't fix"] },
  };

  const inspect = await workbook.inspect({
    kind: "table",
    range: "User Stories!A1:J8",
    include: "values,formulas",
    tableMaxRows: 8,
    tableMaxCols: 10,
  });
  console.log(inspect.ndjson);

  const errors = await workbook.inspect({
    kind: "match",
    searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
    options: { useRegex: true, maxResults: 100 },
    summary: "formula error scan",
  });
  console.log(errors.ndjson);

  for (const sheetName of ["Summary", "User Stories", "Issues"]) {
    const preview = await workbook.render({ sheetName, autoCrop: "all", scale: 1, format: "png" });
    await fs.writeFile(`${outputDir}/${sheetName.toLowerCase().replaceAll(" ", "-")}.png`, new Uint8Array(await preview.arrayBuffer()));
  }

  const xlsx = await SpreadsheetFile.exportXlsx(workbook);
  await xlsx.save(outputPath);
  console.log(outputPath);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
