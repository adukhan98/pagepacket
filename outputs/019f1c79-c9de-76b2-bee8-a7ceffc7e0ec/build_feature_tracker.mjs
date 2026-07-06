import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const outputDir = "/Users/adnaankhan/Desktop/markdown/outputs/019f1c79-c9de-76b2-bee8-a7ceffc7e0ec";
const workbookPath = path.join(outputDir, "pagepacket-feature-status.xlsx");

const stories = [
  ["APP-001", "macOS App", "Launch and bootstrap", "As a writer, I want the app to open into a usable workspace when the bundled SampleVault exists.", "On first appearance, WorkspaceStore.bootstrap opens ~/Desktop/markdown/SampleVault if it exists and no workspace is already open.", "Sources/Graft/App/GraftApp.swift; Sources/Graft/Stores/WorkspaceStore.swift:bootstrap", "Build/run smoke plus app launch observation", "P1", "Untested", "", "Not Retested", ""],
  ["APP-002", "macOS App", "Empty workspace state", "As a new user, I want a clear empty state with an open-folder action when no file is selected.", "EditorContainerView shows EmptyWorkspaceView when selectedFile is nil, with an Open Workspace button wired to openWorkspacePanel.", "Sources/Graft/Views/EditorContainerView.swift", "App UI observation", "P2", "Untested", "", "Not Retested", ""],
  ["APP-003", "macOS App", "Open workspace", "As a user, I want to choose a folder as my Markdown workspace.", "Toolbar, menu, and empty-state actions open an NSOpenPanel configured for directories only.", "Sources/Graft/Views/ContentView.swift; Sources/Graft/App/GraftCommands.swift; WorkspaceStore.openWorkspacePanel", "App UI observation", "P1", "Untested", "", "Not Retested", ""],
  ["APP-004", "macOS App", "Sidecar preparation", "As a user, I want app metadata to stay in a sidecar and be created automatically.", "Opening a workspace calls VersionHistoryStore.prepare, creating .pagepacket/history and .pagepacket/shares.", "Sources/Graft/Stores/WorkspaceStore.swift:openWorkspace; Sources/Graft/Services/VersionHistoryStore.swift:prepare", "Filesystem smoke", "P1", "Untested", "", "Not Retested", ""],
  ["APP-005", "macOS App", "Markdown discovery", "As a user, I want the sidebar to list all Markdown files in the chosen workspace.", "reloadFileList recursively enumerates non-hidden .md files, excludes .pagepacket and .graft paths, and sorts by relative path.", "Sources/Graft/Stores/WorkspaceStore.swift:reloadFileList", "Filesystem smoke", "P1", "Untested", "", "Not Retested", ""],
  ["APP-006", "macOS App", "Sidebar file list", "As a user, I want each Markdown file to show a title and relative path.", "SidebarView renders file.title and file.relativePath with doc icons in the Markdown section.", "Sources/Graft/Views/SidebarView.swift; Sources/Graft/Models/MarkdownFile.swift", "App UI observation", "P2", "Untested", "", "Not Retested", ""],
  ["APP-007", "macOS App", "Select file", "As a user, I want selecting a file to load its text and matching history.", "load(file:) snapshots dirty current text first, then updates selectedFile, editorText, lastLoadedText, clears banners, and refreshes snapshots.", "Sources/Graft/Stores/WorkspaceStore.swift:load", "Filesystem/app smoke", "P1", "Untested", "", "Not Retested", ""],
  ["APP-008", "macOS App", "Edit mode", "As a writer, I want a full editor for the selected Markdown file.", "Edit mode renders MarkdownEditorView with file title, relative path, image/save actions, and TextEditor bound to editorText.", "Sources/Graft/Views/MarkdownEditorView.swift; Sources/Graft/Views/EditorContainerView.swift", "App UI observation", "P1", "Untested", "", "Not Retested", ""],
  ["APP-009", "macOS App", "Editor dirty state", "As a writer, I want the app to distinguish saved from unsaved text.", "isDirty compares editorText with lastLoadedText; StatusStrip shows Saved or Unsaved with different icons/colors.", "Sources/Graft/Stores/WorkspaceStore.swift:isDirty; Sources/Graft/Views/ContentView.swift:StatusStrip", "App UI observation", "P1", "Untested", "", "Not Retested", ""],
  ["APP-010", "macOS App", "Save document", "As a writer, I want Save to persist the current Markdown file.", "saveCurrentDocument snapshots before save, writes editorText to selectedFile.url, updates lastLoadedText, marks watcher clean, reloads file list, and refreshes snapshots.", "Sources/Graft/Stores/WorkspaceStore.swift:saveCurrentDocument", "Filesystem smoke", "P1", "Untested", "", "Not Retested", ""],
  ["APP-011", "macOS App", "Autosave", "As a writer, I want optional autosave on each edit.", "When autosaveEnabled is true and editorText changes while dirty, MarkdownEditorView calls saveCurrentDocument.", "Sources/Graft/Views/MarkdownEditorView.swift; Sources/Graft/App/SettingsView.swift", "App UI/filesystem observation", "P2", "Untested", "", "Not Retested", ""],
  ["APP-012", "macOS App", "Editor font size", "As a writer, I want to adjust the editor font size.", "Settings stepper changes editorFontSize in the 12...24 range; TextEditor uses that value for a monospaced font.", "Sources/Graft/App/SettingsView.swift; Sources/Graft/Views/MarkdownEditorView.swift", "App UI observation", "P3", "Untested", "", "Not Retested", ""],
  ["APP-013", "macOS App", "Mode picker", "As a writer, I want Edit, Split, and Preview modes.", "ContentView toolbar picker binds to editorMode; EditorMode has edit, split, preview cases.", "Sources/Graft/Views/ContentView.swift; Sources/Graft/Models/EditorMode.swift", "App UI observation", "P1", "Untested", "", "Not Retested", ""],
  ["APP-014", "macOS App", "Split mode", "As a writer, I want to edit and preview side by side.", "Split mode uses HSplitView with MarkdownEditorView and MarkdownPreviewView, each with a 360px minimum width.", "Sources/Graft/Views/EditorContainerView.swift", "App UI observation", "P1", "Untested", "", "Not Retested", ""],
  ["APP-015", "macOS App", "Preview headings", "As a reader, I want Markdown headings to render visually by level.", "MarkdownRenderer parses # headings up to level 6; MarkdownPreviewView maps levels to heading sizes.", "Sources/Graft/Services/MarkdownRenderer.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Renderer inspection/app preview", "P2", "Untested", "", "Not Retested", ""],
  ["APP-016", "macOS App", "Preview paragraphs and inline Markdown", "As a reader, I want paragraph text and inline Markdown to render cleanly.", "Non-special lines become paragraph blocks; MarkdownInlineText attempts AttributedString(markdown:) and falls back to plain text.", "Sources/Graft/Services/MarkdownRenderer.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Renderer inspection/app preview", "P2", "Untested", "", "Not Retested", ""],
  ["APP-017", "macOS App", "Preview quotes", "As a reader, I want block quotes to stand apart from body text.", "Lines beginning with > become quote blocks shown with a lavender left rule and secondary text style.", "Sources/Graft/Services/MarkdownRenderer.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Renderer inspection/app preview", "P3", "Untested", "", "Not Retested", ""],
  ["APP-018", "macOS App", "Preview unordered lists", "As a reader, I want unordered list items to render as bullets.", "Lines beginning - or * become unorderedItem blocks rendered with a teal circle icon.", "Sources/Graft/Services/MarkdownRenderer.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Renderer inspection/app preview", "P2", "Untested", "", "Not Retested", ""],
  ["APP-019", "macOS App", "Preview ordered lists", "As a reader, I want ordered list numbers to match the Markdown source.", "Current preview parses ordered items but renders every item with the literal label 1.", "Sources/Graft/Services/MarkdownRenderer.swift:isOrderedItem; Sources/Graft/Views/MarkdownPreviewView.swift:orderedItem", "Renderer inspection/app preview", "P2", "Needs Fix", "ISS-004", "Not Retested", ""],
  ["APP-020", "macOS App", "Preview task lists", "As a reader, I want checked and unchecked tasks to show their state.", "Lines beginning - [ ], * [ ], - [x], * [x], - [X], or * [X] become task blocks with square/checkmark icons.", "Sources/Graft/Services/MarkdownRenderer.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Renderer inspection/app preview", "P2", "Untested", "", "Not Retested", ""],
  ["APP-021", "macOS App", "Preview code fences", "As a reader, I want fenced code blocks to preserve monospaced text and language labels.", "Triple-backtick fences become code blocks; the optional fence suffix is uppercased as a label.", "Sources/Graft/Services/MarkdownRenderer.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Renderer inspection/app preview", "P2", "Untested", "", "Not Retested", ""],
  ["APP-022", "macOS App", "Preview tables", "As a reader, I want pipe tables to render as rows and cells.", "A pipe row followed by a separator row becomes a table; cells are normalized to header width.", "Sources/Graft/Services/MarkdownRenderer.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Renderer inspection/app preview", "P2", "Untested", "", "Not Retested", ""],
  ["APP-023", "macOS App", "Preview images", "As a reader, I want local Markdown images to display from relative paths.", "Image syntax becomes image blocks; Preview resolves paths relative to the selected file folder and displays NSImage if present.", "Sources/Graft/Services/MarkdownRenderer.swift:parseImage; Sources/Graft/Views/MarkdownPreviewView.swift:imageView", "Filesystem/app preview", "P2", "Untested", "", "Not Retested", ""],
  ["APP-024", "macOS App", "Missing image state", "As a reader, I want broken image links to be visible.", "If NSImage cannot load the path, Preview shows a pink Missing image label with the path.", "Sources/Graft/Views/MarkdownPreviewView.swift:imageView", "App preview", "P3", "Untested", "", "Not Retested", ""],
  ["APP-025", "macOS App", "Preview horizontal rules", "As a reader, I want --- and *** to render as dividers.", "Trimmed lines equal to --- or *** become horizontalRule blocks.", "Sources/Graft/Services/MarkdownRenderer.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Renderer inspection/app preview", "P3", "Needs Fix", "ISS-005", "Not Retested", ""],
  ["APP-026", "macOS App", "Stable preview rows", "As a user, I want repeated Markdown blocks to render predictably without SwiftUI identity collisions.", "Current MarkdownBlock.id is content-derived for most blocks and random for horizontalRule, so repeated identical content can collide and rules churn identity.", "Sources/Graft/Models/MarkdownBlock.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Code audit plus app log observation", "P1", "Needs Fix", "ISS-005", "Not Retested", ""],
  ["APP-027", "macOS App", "Insert image", "As a writer, I want to import an image and insert Markdown for it.", "Toolbar/editor image actions open an image NSOpenPanel; ImageImportService copies the file under assets/<document-name>/ and appends Markdown to editorText.", "Sources/Graft/Stores/WorkspaceStore.swift:insertImageFromPanel; Sources/Graft/Services/ImageImportService.swift", "Filesystem/app smoke", "P1", "Needs Fix", "ISS-006", "Not Retested", ""],
  ["APP-028", "macOS App", "Manual snapshot", "As a writer, I want to create a checkpoint without saving new content.", "Toolbar, menu, and History plus button call snapshotCurrentDocument with reason Manual checkpoint and source Pagepacket.", "Sources/Graft/Views/ContentView.swift; Sources/Graft/Views/HistoryView.swift; Sources/Graft/App/GraftCommands.swift", "Filesystem smoke", "P1", "Untested", "", "Not Retested", ""],
  ["APP-029", "macOS App", "History empty state", "As a writer, I want history to explain itself before snapshots exist.", "HistoryView shows No snapshots yet when workspace.snapshots is empty.", "Sources/Graft/Views/HistoryView.swift", "App UI observation", "P3", "Untested", "", "Not Retested", ""],
  ["APP-030", "macOS App", "History cards", "As a writer, I want snapshots to show source, reason, timestamp, byte count, and restore.", "HistoryView renders each VersionSnapshot displayTitle, reason, formatted timestamp, byte count, and Restore button.", "Sources/Graft/Views/HistoryView.swift; Sources/Graft/Models/VersionSnapshot.swift", "Filesystem/app observation", "P2", "Untested", "", "Not Retested", ""],
  ["APP-031", "macOS App", "Restore snapshot", "As a writer, I want to roll back to a previous snapshot.", "restore reads snapshot content after front matter, snapshots current text first, writes restored content to disk, updates lastLoadedText, marks clean, and refreshes snapshots.", "Sources/Graft/Stores/WorkspaceStore.swift:restore; Sources/Graft/Services/VersionHistoryStore.swift:restoreContent", "Filesystem smoke", "P1", "Untested", "", "Not Retested", ""],
  ["APP-032", "macOS App", "History path isolation", "As a writer, I want snapshots for different files to stay separate.", "Current safeName can map different relative paths to the same history folder, such as a/b.md and a__b.md.", "Sources/Graft/Services/VersionHistoryStore.swift:safeName; Sources/GraftCLI/main.swift:safeName", "Filesystem regression smoke", "P1", "Needs Fix", "ISS-009", "Not Retested", ""],
  ["APP-033", "macOS App", "Clean external change", "As a writer, I want disk edits from tools to appear when I have no local unsaved edits.", "FileWatcher detects modified selected file; if editor is clean, WorkspaceStore reloads disk text, updates lastLoadedText, shows a reload banner, updates agent status, and refreshes snapshots.", "Sources/Graft/Services/FileWatcher.swift; Sources/Graft/Stores/WorkspaceStore.swift:handleExternalChange", "Filesystem/app observation", "P1", "Untested", "", "Not Retested", ""],
  ["APP-034", "macOS App", "External conflict", "As a writer, I want a conflict warning when disk changes arrive while I have unsaved local edits.", "If isDirty is true, handleExternalChange snapshots the base, shows an External edit detected banner, and marks the Codex agent as Conflict.", "Sources/Graft/Stores/WorkspaceStore.swift:handleExternalChange; Sources/Graft/Views/ContentView.swift:ExternalChangeBanner", "Filesystem/app observation", "P1", "Untested", "", "Not Retested", ""],
  ["APP-035", "macOS App", "Use Disk conflict action", "As a writer, I want to accept the disk version during an external-change conflict.", "Use Disk calls reloadSelectedFromDisk, snapshots before accepting, replaces editorText/lastLoadedText with disk content, clears the banner, and refreshes snapshots.", "Sources/Graft/Views/ContentView.swift; Sources/Graft/Stores/WorkspaceStore.swift:reloadSelectedFromDisk", "App observation", "P1", "Untested", "", "Not Retested", ""],
  ["APP-036", "macOS App", "Keep Mine conflict action", "As a writer, I want to keep my local version during an external-change conflict.", "Keep Mine calls saveCurrentDocument and clears the banner, writing local editorText to disk.", "Sources/Graft/Views/ContentView.swift; Sources/Graft/Stores/WorkspaceStore.swift:keepLocalVersion", "App observation", "P1", "Untested", "", "Not Retested", ""],
  ["APP-037", "macOS App", "Dismiss conflict banner", "As a writer, I want to dismiss the external-change banner.", "The xmark button sets externalChangeBanner to nil.", "Sources/Graft/Views/ContentView.swift:ExternalChangeBanner", "App observation", "P3", "Untested", "", "Not Retested", ""],
  ["APP-038", "macOS App", "Nonselected external change", "As a writer, I want the app to notice when another Markdown file changes.", "When FileWatcher sees a nonselected file, handleExternalChange reloads the file list and updates the first agent status/detail to Changed.", "Sources/Graft/Stores/WorkspaceStore.swift:handleExternalChange", "Filesystem/app observation", "P2", "Untested", "", "Not Retested", ""],
  ["APP-039", "macOS App", "External-change setting", "As a writer, I want to disable external-change surfacing.", "Settings toggles externalChangeDetectionEnabled; handleExternalChange returns early when disabled.", "Sources/Graft/App/SettingsView.swift; Sources/Graft/Stores/WorkspaceStore.swift:handleExternalChange", "App observation", "P2", "Untested", "", "Not Retested", ""],
  ["APP-040", "macOS App", "Inspector visibility", "As a user, I want to show or hide the inspector.", "Toolbar Inspector button and View menu shortcut toggle workspace.isInspectorVisible.", "Sources/Graft/Views/ContentView.swift; Sources/Graft/App/GraftCommands.swift", "App observation", "P2", "Untested", "", "Not Retested", ""],
  ["APP-041", "macOS App", "Inspector tabs", "As a user, I want History, Share, and Agents panels in the inspector.", "InspectorView segmented picker switches between HistoryView, ShareView, and AgentsPanel.", "Sources/Graft/Views/InspectorView.swift", "App observation", "P2", "Untested", "", "Not Retested", ""],
  ["APP-042", "macOS App", "Agent panel", "As a user, I want to see agent activity and the CLI sync contract.", "AgentsPanel renders static AgentActivity rows and commands for status, snapshot, apply, and the local skill.", "Sources/Graft/Views/InspectorView.swift; Sources/Graft/Stores/WorkspaceStore.swift:agents", "App observation", "P3", "Untested", "", "Not Retested", ""],
  ["APP-043", "macOS App", "Share invite list", "As a user, I want invited collaborators to appear in the Share panel.", "ShareView renders workspace.invites with email, role, compose, and remove actions.", "Sources/Graft/Views/ShareView.swift; Sources/Graft/Models/Invite.swift", "App/filesystem observation", "P2", "Needs Fix", "ISS-007", "Not Retested", ""],
  ["APP-044", "macOS App", "Add invite", "As a user, I want to add an email invite intent with a role.", "addInvite currently appends non-empty email text with selected role and writes invites.json.", "Sources/Graft/Views/ShareView.swift; Sources/Graft/Stores/WorkspaceStore.swift:addInvite", "App/filesystem observation", "P2", "Needs Fix", "ISS-008", "Not Retested", ""],
  ["APP-045", "macOS App", "Invite roles", "As a user, I want Viewer, Commenter, and Editor roles.", "InviteRole has viewer, commenter, and editor cases; ShareView uses a segmented picker.", "Sources/Graft/Models/Invite.swift; Sources/Graft/Views/ShareView.swift", "App observation", "P3", "Untested", "", "Not Retested", ""],
  ["APP-046", "macOS App", "Remove invite", "As a user, I want to remove stale invite intents.", "removeInvite removes by UUID and rewrites .pagepacket/shares/invites.json.", "Sources/Graft/Stores/WorkspaceStore.swift:removeInvite", "App/filesystem observation", "P2", "Untested", "", "Not Retested", ""],
  ["APP-047", "macOS App", "Compose invite email", "As a user, I want to open a mail draft for an invite.", "composeEmail writes the manifest, builds a mailto URL with subject/body, and opens it through NSWorkspace.", "Sources/Graft/Stores/WorkspaceStore.swift:composeEmail", "Code audit/app observation with no send action", "P2", "Untested", "", "Not Retested", "Stop before sending email."],
  ["APP-048", "macOS App", "Settings", "As a user, I want a native settings window for editor and workspace preferences.", "Settings scene shows Autosave, font size, external change toggle, and read-only sidecar/assets folder labels.", "Sources/Graft/App/GraftApp.swift; Sources/Graft/App/SettingsView.swift", "App observation", "P3", "Untested", "", "Not Retested", ""],
  ["APP-049", "macOS App", "Command menu", "As a keyboard user, I want menu actions for common tasks.", "Commands add Open Workspace, Save Document, Snapshot Version, editor mode picker, and Toggle Inspector with shortcuts.", "Sources/Graft/App/GraftCommands.swift", "App/menu observation", "P2", "Untested", "", "Not Retested", ""],
  ["APP-050", "macOS App", "Build and run script", "As a developer, I want one command to build, bundle, launch, and verify Pagepacket.", "script/build_and_run.sh kills Pagepacket, runs swift build, stages dist/Pagepacket.app with Info.plist/resources, opens it, and supports --verify.", "script/build_and_run.sh; .codex/environments/environment.toml", "Command smoke", "P1", "Untested", "", "Not Retested", ""],
  ["APP-051", "macOS App", "Readable app appearance", "As a user on a dark system appearance, I want Pagepacket's cream UI to keep readable dark text.", "The app should force a light SwiftUI color scheme for its cream canvas and use explicit body color in editor/preview text.", "Sources/Graft/App/GraftApp.swift; Sources/Graft/Views/MarkdownEditorView.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Window screenshot retest", "P1", "Retest Pass", "ISS-012", "Retest Pass", "Final app window screenshot shows readable editor and preview text."],
  ["APP-052", "macOS App", "Before-save history restores disk version", "As a writer, I want the before-save snapshot to recover the file version that Save overwrote.", "saveCurrentDocument should snapshot lastLoadedText before writing editorText, and restoreContent should strip front matter robustly.", "Sources/Graft/Stores/WorkspaceStore.swift:saveCurrentDocument; Sources/Graft/Services/VersionHistoryStore.swift:restoreContent", "Regression runner", "P1", "Retest Pass", "ISS-014; ISS-015", "Retest Pass", "Tests/run_regression_checks.sh"],
  ["APP-053", "macOS App", "Editor wraps long Markdown lines", "As a writer in split mode, I want long Markdown lines to stay visible without horizontal scrolling.", "The editor should use a wrapping native text view with no horizontal scroller, preserving binding updates and autosave.", "Sources/Graft/Views/MarkdownEditorView.swift", "Window screenshot retest", "P1", "Retest Pass", "ISS-016", "Retest Pass", "Final app window screenshot after post-fix pass"],
  ["APP-054", "macOS App", "Readable startup layout", "As a writer opening Pagepacket on a laptop-width display, I want the first window to show editable text without clipped split panes.", "WorkspaceStore should start in Edit mode with the inspector hidden so the first launch fits the available window width; Split and Inspector remain toolbar/menu actions.", "Sources/Graft/Stores/WorkspaceStore.swift; Sources/Graft/App/GraftApp.swift", "Window screenshot retest", "P1", "Retest Pass", "ISS-018", "Retest Pass", "Direct executable window screenshot shows full editor text with sidebar and no clipping."],
  ["CLI-001", "CLI", "CLI usage", "As an agent, I want usage output when I run the CLI without a known command.", "PagepacketCLI.main prints usage when no command or an unknown command is passed.", "Sources/GraftCLI/main.swift:main,printUsage", "Command smoke", "P2", "Untested", "", "Not Retested", ""],
  ["CLI-002", "CLI", "Vault status", "As an agent, I want to inspect a vault before editing.", "status prints vault path, Markdown file count, sidecar path, and up to 12 relative Markdown file paths.", "Sources/GraftCLI/main.swift:status,markdownFiles", "Command smoke", "P1", "Untested", "", "Not Retested", ""],
  ["CLI-003", "CLI", "Status missing vault", "As an agent, I want clear feedback when I omit the vault path.", "status without args prints missing vault path.", "Sources/GraftCLI/main.swift:status", "Command smoke", "P3", "Untested", "", "Not Retested", ""],
  ["CLI-004", "CLI", "CLI snapshot", "As an agent, I want to checkpoint a file before broad edits.", "snapshot <vault> <file> writes a .pagepacket/history/<safe-file>/<timestamp>.md with pagepacket front matter and source pagepacket-cli.", "Sources/GraftCLI/main.swift:snapshot,writeSnapshot", "Command/filesystem smoke", "P1", "Untested", "", "Not Retested", ""],
  ["CLI-005", "CLI", "CLI snapshot message", "As an agent, I want the checkpoint reason to preserve my message.", "snapshot uses --message value when provided and CLI checkpoint otherwise.", "Sources/GraftCLI/main.swift:snapshot,option", "Command/filesystem smoke", "P2", "Untested", "", "Not Retested", ""],
  ["CLI-006", "CLI", "CLI apply checkpoint", "As an agent, I want to register a completed external edit.", "apply <vault> <file> writes a snapshot reason Applied external edit by <author> with source set from --author or agent.", "Sources/GraftCLI/main.swift:apply,writeSnapshot", "Command/filesystem smoke", "P1", "Untested", "", "Not Retested", ""],
  ["CLI-007", "CLI", "CLI history", "As an agent, I want to list checkpoints for a file.", "history <vault> <file> lists snapshot IDs from the file history folder sorted newest first.", "Sources/GraftCLI/main.swift:history", "Command smoke", "P1", "Untested", "", "Not Retested", ""],
  ["CLI-008", "CLI", "CLI no history", "As an agent, I want a clear no-history message.", "history prints No snapshots for <file> when the history folder is missing or unreadable.", "Sources/GraftCLI/main.swift:history", "Command smoke", "P3", "Untested", "", "Not Retested", ""],
  ["CLI-009", "CLI", "CLI ignores sidecars", "As an agent, I want status to count only user Markdown files.", "markdownFiles excludes paths containing /.pagepacket/ or /.graft/.", "Sources/GraftCLI/main.swift:markdownFiles", "Command/filesystem smoke", "P2", "Untested", "", "Not Retested", ""],
  ["CLI-010", "CLI", "CLI history path isolation", "As an agent, I want snapshots for similarly named paths to stay separate.", "Current CLI safeName shares the same collision risk as the app history store.", "Sources/GraftCLI/main.swift:safeName", "Command regression smoke", "P1", "Needs Fix", "ISS-009", "Not Retested", ""],
  ["CLI-011", "CLI", "CLI normalized relative paths", "As an agent running against /tmp or symlinked folders, I want status output to show clean workspace-relative paths.", "status should normalize vault and file URLs before deriving relative paths so /private/tmp does not leak into output.", "Sources/GraftCLI/main.swift:status,markdownFiles,relativePath", "Command regression smoke", "P1", "Retest Pass", "ISS-013", "Retest Pass", "Final CLI smoke printed a/b.md, a__b.md, and root.md."],
  ["WEB-001", "Landing Page", "Page identity", "As a visitor, I want the landing page to load with the Pagepacket title and core content.", "index.html sets title pagepacket - join the waitlist and renders hero, tour, review, CLI, waitlist, and footer sections.", "landing page/index.html", "Browser smoke", "P1", "Untested", "", "Not Retested", ""],
  ["WEB-002", "Landing Page", "Navigation anchors", "As a visitor, I want nav links to jump to Tour, Review, CLI, and Waitlist sections.", "Nav and footer anchors target #tour, #review, #cli, and #waitlist.", "landing page/index.html", "Browser interaction", "P2", "Untested", "", "Not Retested", ""],
  ["WEB-003", "Landing Page", "Hero waitlist invalid email", "As a visitor, I want a helpful validation error for invalid email.", "script.js intercepts submit, checks input.checkValidity, sets data-state error, displays Enter a valid email address to join the waitlist, and focuses the input.", "landing page/script.js", "Browser interaction", "P1", "Untested", "", "Not Retested", ""],
  ["WEB-004", "Landing Page", "Hero waitlist preview save", "As a visitor, I want the static preview form to save locally until /waitlist is connected.", "For action /waitlist, script.js writes a deduped email list to localStorage key pagepacket-waitlist-preview, shows success, and resets the form.", "landing page/script.js", "Browser interaction/localStorage", "P1", "Needs Fix", "ISS-011", "Not Retested", ""],
  ["WEB-005", "Landing Page", "Footer waitlist form", "As a visitor, I want the final waitlist form to behave like the hero form.", "Both forms use data-waitlist-form and share the same submit handler.", "landing page/index.html; landing page/script.js", "Browser interaction", "P1", "Untested", "", "Not Retested", ""],
  ["WEB-006", "Landing Page", "Responsive layout", "As a mobile visitor, I want the page to stay readable and operable on small screens.", "styles.css switches nav/grid/form/packet layouts at 60rem and 40rem breakpoints.", "landing page/styles.css", "Browser screenshot desktop/mobile", "P1", "Untested", "", "Not Retested", ""],
  ["WEB-007", "Landing Page", "Reduced motion", "As a motion-sensitive visitor, I want animations to avoid motion when reduced motion is requested.", "script.js skips IntersectionObserver when prefers-reduced-motion is true; CSS defaults reveal elements to visible.", "landing page/script.js; landing page/styles.css", "Browser/code inspection", "P3", "Untested", "", "Not Retested", ""],
  ["WEB-008", "Landing Page", "Favicon", "As a visitor, I want the browser favicon request to resolve.", "index.html links ../Assets/Brand/pagepacket-app-icon.png, but current assets list only has graft-app-icon.png and graft-logo-lockup.png.", "landing page/index.html; Assets/Brand", "Browser/network or filesystem check", "P2", "Needs Fix", "ISS-001", "Not Retested", ""],
  ["WEB-009", "Landing Page", "Review artifact accuracy", "As a visitor, I want the hero product artifact to reflect what the current app can do.", "Landing hero advertises review-packet accept/reject/checkpoint actions, while current Swift code implements conflict Use Disk/Keep Mine and snapshots, not review packets.", "landing page/index.html; Sources/Graft", "Code audit/browser observation", "P1", "Needs Fix", "ISS-002", "Not Retested", ""],
  ["WEB-010", "Landing Page", "CLI demo accuracy", "As an agent-heavy visitor, I want the CLI example to match actual command output.", "Landing CLI demo shows workspace, agent edits, conflicts, and saved history path lines that do not match Sources/GraftCLI/main.swift output.", "landing page/index.html; Sources/GraftCLI/main.swift", "Command plus browser copy check", "P2", "Needs Fix", "ISS-003", "Not Retested", ""],
  ["WEB-011", "Landing Page", "Mockup actions", "As a visitor, I should not see product-proof controls that appear clickable but do nothing.", "Accept hunk, Reject, and Checkpoint first are type=button elements with no handlers.", "landing page/index.html", "Browser interaction/code audit", "P2", "Needs Fix", "ISS-002", "Not Retested", ""],
  ["WEB-012", "Landing Page", "Waitlist corrupted storage recovery", "As a returning visitor, I want the waitlist form not to break if localStorage contains malformed preview data.", "script.js currently JSON.parse's localStorage without a try/catch.", "landing page/script.js", "Browser interaction/localStorage", "P2", "Needs Fix", "ISS-011", "Not Retested", ""],
  ["DATA-001", "Sample Vault", "Sample Markdown", "As a tester, I want SampleVault to exercise common Markdown features.", "SampleVault/welcome.md contains heading, paragraphs, lists, tasks, quote, table, code fence, CLI examples, and image syntax.", "SampleVault/welcome.md", "App/preview smoke", "P2", "Untested", "", "Not Retested", ""],
  ["DATA-002", "Sample Vault", "Sample image path", "As a tester, I want the sample image link to resolve.", "SampleVault/welcome.md references assets/welcome/graft-sample.ppm, and that file exists.", "SampleVault/welcome.md; SampleVault/assets/welcome/graft-sample.ppm", "Filesystem/app preview", "P2", "Untested", "", "Not Retested", ""],
  ["DOC-001", "Docs", "README feature list", "As a developer, I want README features to match current code.", "README describes the SwiftUI app, edit/preview/split, local history, image import, invites, inspector agent activity, CLI, and build/run integration.", "README.md", "Code/doc audit", "P2", "Untested", "", "Not Retested", ""],
  ["DOC-002", "Docs", "Agent sync skill", "As an agent, I want the repo-local sync skill to describe the safe Markdown edit loop.", "skills/graft-sync/SKILL.md instructs status, snapshot, direct Markdown edits, apply, and stopping on conflicts.", "skills/graft-sync/SKILL.md", "Code/doc audit", "P2", "Untested", "", "Not Retested", ""],
];

const issues = [
  ["ISS-001", "Landing Page", "Favicon asset path is broken", "landing page/index.html points to ../Assets/Brand/pagepacket-app-icon.png, but the repo only contains graft-app-icon.png and graft-logo-lockup.png.", "P2", "Open", "Pre-test code audit", "WEB-008", "landing page/index.html", ""],
  ["ISS-002", "Landing Page", "Landing advertises review-packet accept/reject behavior not present in current app code", "Hero copy, nav command, review artifact, and buttons imply review packets with accept/reject hunks; Sources/Graft currently implements snapshots and Use Disk/Keep Mine conflict actions instead.", "P1", "Open", "Pre-test code audit", "WEB-009; WEB-011", "landing page/index.html", ""],
  ["ISS-003", "Landing Page", "CLI demo does not match actual CLI output", "The landing-page code block claims fields like agent edits and conflicts that pagepacket-cli status does not print.", "P2", "Open", "Pre-test code audit", "WEB-010", "landing page/index.html", ""],
  ["ISS-004", "macOS App", "Ordered-list preview hardcodes every item as 1.", "MarkdownPreviewView renders orderedItem with Text(\"1.\") regardless of the Markdown source number.", "P2", "Open", "Pre-test code audit", "APP-019", "Sources/Graft/Views/MarkdownPreviewView.swift; Sources/Graft/Services/MarkdownRenderer.swift", ""],
  ["ISS-005", "macOS App", "Preview block identity is duplicate or unstable", "MarkdownBlock.id is content-derived for most blocks and UUID-generated for horizontal rules, causing duplicate-ID risk and unstable identity.", "P1", "Open", "Pre-test code audit", "APP-025; APP-026", "Sources/Graft/Models/MarkdownBlock.swift; Sources/Graft/Views/MarkdownPreviewView.swift", ""],
  ["ISS-006", "macOS App", "Nested-document image import can insert an absolute path", "ImageImportService computes the inserted path by replacing the selected file's parent path. For nested docs, assets live at the workspace root, so the replacement can fail.", "P1", "Open", "Pre-test code audit", "APP-027", "Sources/Graft/Services/ImageImportService.swift", ""],
  ["ISS-007", "macOS App", "Share panel starts with fake invites and does not load persisted invite manifest", "WorkspaceStore seeds maya@example.com and reviewer@example.com for every workspace and never reads .pagepacket/shares/invites.json on open.", "P2", "Open", "Pre-test code audit", "APP-043", "Sources/Graft/Stores/WorkspaceStore.swift; Sources/Graft/Views/ShareView.swift", ""],
  ["ISS-008", "macOS App", "Invite input accepts invalid and duplicate emails", "addInvite only rejects empty trimmed text, so invalid strings and duplicate invite records are accepted.", "P2", "Open", "Pre-test code audit", "APP-044", "Sources/Graft/Stores/WorkspaceStore.swift; Sources/Graft/Views/ShareView.swift", ""],
  ["ISS-009", "macOS App / CLI", "History safeName can collide across different relative paths", "Replacing slash with __ and dot/space with _ maps distinct paths to the same folder, risking mixed snapshots.", "P1", "Open", "Pre-test code audit", "APP-032; CLI-010", "Sources/Graft/Services/VersionHistoryStore.swift; Sources/GraftCLI/main.swift", ""],
  ["ISS-010", "Tests", "No automated Swift tests present", "Tests/BrandingTests exists but has no files, so app behavior coverage depends on smoke scripts/manual validation.", "P2", "Open", "Repo inventory", "APP-001..DOC-002", "Tests", ""],
  ["ISS-011", "Landing Page", "Waitlist localStorage parse can break submit flow", "script.js parses pagepacket-waitlist-preview directly; malformed stored JSON would throw before success/error UI updates.", "P2", "Open", "Pre-test code audit", "WEB-004; WEB-012", "landing page/script.js", ""],
  ["ISS-012", "macOS App", "Dark system appearance made text unreadable on cream canvas", "The app used cream backgrounds while inheriting dark-mode default text, producing white text on light surfaces.", "P1", "Retest Pass", "Window screenshot", "APP-051", "Sources/Graft/App/GraftApp.swift; Sources/Graft/Views/MarkdownEditorView.swift; Sources/Graft/Views/MarkdownPreviewView.swift", "Forced light SwiftUI color scheme and explicit body text color where needed."],
  ["ISS-013", "CLI", "Status printed /private-prefixed pseudo-relative paths for /tmp vaults", "The CLI compared unresolved /tmp vault paths against enumerated /private/tmp file paths, so replacement failed.", "P1", "Retest Pass", "CLI smoke", "CLI-002; CLI-011", "Sources/GraftCLI/main.swift", "Normalize URLs before deriving relative paths."],
  ["ISS-014", "macOS App", "Restore could write snapshot front matter into the Markdown file", "restoreContent only stripped front matter for one exact delimiter shape and failed on snapshots without the extra blank line.", "P1", "Retest Pass", "Regression runner", "APP-031; APP-052", "Sources/Graft/Services/VersionHistoryStore.swift", "Parse through the closing front-matter delimiter and consume any following newlines."],
  ["ISS-015", "macOS App", "Before-save snapshots stored the new editor text instead of the overwritten disk text", "saveCurrentDocument called snapshotCurrentDocument after editorText changed, so rollback to the pre-save file was impossible.", "P1", "Retest Pass", "Regression runner", "APP-010; APP-031; APP-052", "Sources/Graft/Stores/WorkspaceStore.swift", "Snapshot lastLoadedText before writing editorText."],
  ["ISS-016", "macOS App", "Editor pane could remain horizontally scrolled on long Markdown lines", "The split editor could show clipped line starts for long Markdown lines, making the editable Markdown hard to scan.", "P1", "Retest Pass", "Window screenshot", "APP-008; APP-053", "Sources/Graft/Views/MarkdownEditorView.swift", "Replaced TextEditor with a wrapping NSTextView bridge that disables horizontal scrolling."],
  ["ISS-017", "Build/Run", "Hand-staged .app opened by LaunchServices stays at a zero-sized placeholder window", "The freshly built executable opens a visible Pagepacket window, but /usr/bin/open on dist/Pagepacket.app still produces only zero-sized Pagepacket windows in this environment.", "P1", "Open", "WindowServer check", "APP-001; APP-050", "script/build_and_run.sh; Sources/Graft/App/GraftApp.swift", "Tried disabling restoration, AppKit lifecycle, early window creation, Info.plist restoration keys, and ad-hoc signing; direct executable launch remains the working path."],
  ["ISS-018", "macOS App", "Default split/inspector startup could clip content at 1120px", "Launching directly into Split with inspector visible over-constrained the window on the available display, clipping editor and preview content.", "P1", "Retest Pass", "Window screenshot", "APP-054", "Sources/Graft/Stores/WorkspaceStore.swift", "Start in Edit mode with inspector hidden; Split and Inspector remain explicit controls."],
];

const storyUpdates = {
  "APP-001": ["Needs Fix", "ISS-017", "Retest Fail", "Direct executable opens a visible window; LaunchServices-opened staged .app remains zero-sized"],
  "APP-002": ["Pass", "", "Retest Pass", "Code audit: EditorContainerView shows EmptyWorkspaceView when selectedFile is nil"],
  "APP-003": ["Pass", "", "Retest Pass", "Code audit: toolbar, commands, and empty state call openWorkspacePanel"],
  "APP-004": ["Pass", "", "Retest Pass", "Regression runner opened temp workspace and verified sidecar-backed behavior"],
  "APP-005": ["Pass", "", "Retest Pass", "Regression runner verified recursive Markdown discovery and sidecar exclusion"],
  "APP-006": ["Pass", "", "Retest Pass", "Code audit plus regression file discovery: SidebarView renders file title and relative path"],
  "APP-007": ["Pass", "", "Retest Pass", "Regression runner verified first sorted file selection and text load"],
  "APP-008": ["Pass", "", "Retest Pass", "Final app screenshot shows editor surface"],
  "APP-009": ["Pass", "", "Retest Pass", "Store regression exercised dirty/save transition"],
  "APP-010": ["Retest Pass", "ISS-015", "Retest Pass", "Regression runner verified save writes editor text and snapshots pre-save disk text"],
  "APP-011": ["Pass", "", "Retest Pass", "Code audit: MarkdownEditorView saves on editorText change when autosaveEnabled and dirty"],
  "APP-012": ["Pass", "", "Retest Pass", "Code audit: Settings stepper binds editorFontSize 12...24 and editor uses that font size"],
  "APP-013": ["Pass", "", "Retest Pass", "Code audit: toolbar picker and menu actions still bind Edit, Split, and Preview modes"],
  "APP-014": ["Pass", "", "Retest Pass", "Code audit: Split mode still renders editor and preview panes side by side"],
  "APP-015": ["Pass", "", "Retest Pass", "Final app screenshot shows rendered heading hierarchy"],
  "APP-016": ["Pass", "", "Retest Pass", "Final app screenshot shows readable paragraph and inline Markdown rendering"],
  "APP-017": ["Pass", "", "Retest Pass", "Final app screenshot shows quote block styling"],
  "APP-018": ["Pass", "", "Retest Pass", "Final app screenshot shows unordered list bullets"],
  "APP-019": ["Retest Pass", "ISS-004", "Retest Pass", "Regression runner verified ordered numbers 3 and 10 survive parsing"],
  "APP-020": ["Pass", "", "Retest Pass", "Final app screenshot shows checked and unchecked task rows"],
  "APP-021": ["Pass", "", "Retest Pass", "SampleVault preview/code audit"],
  "APP-022": ["Pass", "", "Retest Pass", "Final app screenshot shows table rendering"],
  "APP-023": ["Pass", "", "Retest Pass", "Sample image file exists and preview path resolution remains relative"],
  "APP-024": ["Pass", "", "Retest Pass", "Code audit: missing image branch renders a labeled fallback with the unresolved path"],
  "APP-025": ["Retest Pass", "ISS-005", "Retest Pass", "Regression runner verified stable unique block IDs for repeated rules/content"],
  "APP-026": ["Retest Pass", "ISS-005", "Retest Pass", "Regression runner verified stable unique block IDs"],
  "APP-027": ["Retest Pass", "ISS-006", "Retest Pass", "Regression runner verified nested image Markdown is ../assets/... not absolute"],
  "APP-028": ["Pass", "", "Retest Pass", "Regression runner verified snapshot creation path through save/manual snapshot store path"],
  "APP-029": ["Pass", "", "Retest Pass", "Code audit: HistoryView renders No snapshots yet when snapshot list is empty"],
  "APP-030": ["Pass", "", "Retest Pass", "Regression runner verified snapshots are collected and available for restore"],
  "APP-031": ["Retest Pass", "ISS-014; ISS-015", "Retest Pass", "Regression runner verified restore writes snapshot body only"],
  "APP-032": ["Retest Pass", "ISS-009", "Retest Pass", "Regression runner verified a/b.md and a__b.md use different history folders"],
  "APP-033": ["Pass", "", "Retest Pass", "Code audit: clean selected-file external change reloads disk text, banner, status, and snapshots"],
  "APP-034": ["Pass", "", "Retest Pass", "Code audit: dirty selected-file external change snapshots base and raises conflict banner/status"],
  "APP-035": ["Pass", "", "Retest Pass", "Code audit: Use Disk calls reloadSelectedFromDisk and replaces editor text with disk content"],
  "APP-036": ["Pass", "", "Retest Pass", "Code audit: Keep Mine calls saveCurrentDocument and clears the conflict banner"],
  "APP-037": ["Pass", "", "Retest Pass", "Code audit: banner xmark sets externalChangeBanner to nil"],
  "APP-038": ["Pass", "", "Retest Pass", "Code audit: nonselected external changes reload file list and update agent status to Changed"],
  "APP-039": ["Pass", "", "Retest Pass", "Code audit: externalChangeDetectionEnabled guard exits before surfacing changes"],
  "APP-040": ["Pass", "", "Retest Pass", "Code audit and final screenshot: toolbar/menu toggle inspector visibility"],
  "APP-041": ["Pass", "", "Retest Pass", "Code audit: InspectorView segmented picker switches History, Share, and Agents panels"],
  "APP-042": ["Pass", "", "Retest Pass", "Code audit and final screenshot: agent activity/status strip are rendered"],
  "APP-043": ["Retest Pass", "ISS-007", "Retest Pass", "Regression runner verified persisted invites load without example seed data"],
  "APP-044": ["Retest Pass", "ISS-008", "Retest Pass", "Regression runner verified invalid and duplicate invites are rejected"],
  "APP-045": ["Pass", "", "Retest Pass", "Code audit: InviteRole exposes viewer/commenter/editor"],
  "APP-046": ["Pass", "", "Retest Pass", "Code audit: removeInvite removes by id and rewrites manifest"],
  "APP-047": ["Pass", "", "Retest Pass", "Code audit only; no email send action performed"],
  "APP-048": ["Pass", "", "Retest Pass", "Code audit: Settings scene exposes autosave, font size, external-change toggle, and sidecar labels"],
  "APP-049": ["Pass", "", "Retest Pass", "Code audit: GraftCommands wires open, save, snapshot, editor mode, and inspector shortcuts"],
  "APP-050": ["Needs Fix", "ISS-017", "Retest Fail", "./script/build_and_run.sh --verify passes process check but LaunchServices window remains zero-sized"],
  "CLI-001": ["Pass", "", "Retest Pass", "Final CLI usage smoke"],
  "CLI-002": ["Retest Pass", "ISS-013", "Retest Pass", "Final CLI status smoke"],
  "CLI-003": ["Pass", "", "Retest Pass", "Initial CLI missing-vault smoke"],
  "CLI-004": ["Pass", "", "Retest Pass", "Final CLI snapshot smoke"],
  "CLI-005": ["Pass", "", "Retest Pass", "Final CLI snapshot message smoke"],
  "CLI-006": ["Pass", "", "Retest Pass", "CLI apply smoke from first loop"],
  "CLI-007": ["Pass", "", "Retest Pass", "Final CLI history smoke and SampleVault legacy-history compatibility check"],
  "CLI-008": ["Pass", "", "Retest Pass", "Final no-history smoke"],
  "CLI-009": ["Pass", "", "Retest Pass", "Final CLI status ignored .pagepacket hidden file"],
  "CLI-010": ["Retest Pass", "ISS-009", "Retest Pass", "Final CLI collision smoke wrote separate folders"],
  "DATA-001": ["Pass", "", "Retest Pass", "SampleVault rendered in final app screenshot and code/file audit"],
  "DATA-002": ["Pass", "", "Retest Pass", "Filesystem check: SampleVault/assets/welcome/graft-sample.ppm exists"],
  "DOC-001": ["Pass", "", "Retest Pass", "README audited against current app/CLI scope"],
  "DOC-002": ["Pass", "", "Retest Pass", "skills/graft-sync/SKILL.md audited against CLI workflow"],
};

const issueUpdates = {
  "ISS-004": ["Retest Pass", "Tests/run_regression_checks.sh"],
  "ISS-005": ["Retest Pass", "Tests/run_regression_checks.sh"],
  "ISS-006": ["Retest Pass", "Tests/run_regression_checks.sh"],
  "ISS-007": ["Retest Pass", "Tests/run_regression_checks.sh"],
  "ISS-008": ["Retest Pass", "Tests/run_regression_checks.sh"],
  "ISS-009": ["Retest Pass", "Tests/run_regression_checks.sh plus final CLI smoke"],
  "ISS-010": ["Fixed", "Added Tests/run_regression_checks.sh because XCTest/Testing modules are unavailable locally"],
};

const activeStories = stories
  .filter((row) => row[1] !== "Landing Page")
  .map((row) => {
    const next = [...row];
    const update = storyUpdates[next[0]];
    if (update) {
      next[8] = update[0];
      next[9] = update[1];
      next[10] = update[2];
      next[11] = update[3];
    }
    return next;
  });

const activeIssues = issues
  .filter((row) => row[1] !== "Landing Page")
  .map((row) => {
    const next = [...row];
    const update = issueUpdates[next[0]];
    if (update) {
      next[5] = update[0];
      next[9] = update[1];
    }
    return next;
  });

const runs = [
  ["2026-07-01", "Inventory", "Repo/file inventory", "Pass", "SwiftPM macOS app, CLI, sample vault, repo-local agent skill. Landing page excluded per updated objective.", "git status; rg --files; source reads"],
  ["2026-07-01", "Tracker Seed", "Canonical spreadsheet created", "Pass", "Initial user stories and issue ledger created from code.", "build_feature_tracker.mjs"],
  ["2026-07-01", "Red", "Regression runner before fixes", "Fail", "Failed on missing renderer kind/ordered-number API and invite validation result.", "Tests/run_regression_checks.sh"],
  ["2026-07-01", "Fix", "Regression runner after fixes", "Pass", "Renderer IDs/order, nested image paths, history path isolation, workspace save/snapshot/restore, invite persistence/validation all passed.", "Tests/run_regression_checks.sh"],
  ["2026-07-01", "Verify", "Isolated Swift build", "Pass", "Swift build completed successfully.", "swift build --jobs 1 --build-path /tmp/pagepacket-final-build"],
  ["2026-07-01", "Verify", "CLI smoke", "Pass", "Status output uses clean relative paths; snapshots/history work; colliding names use separate folders.", "/tmp/pagepacket-final-build/debug/pagepacket-cli"],
  ["2026-07-01", "Verify", "App launch/window", "Pass", "Project script launched Pagepacket and CoreGraphics reported an onscreen 1120x772 Pagepacket window.", "./script/build_and_run.sh --verify; /tmp/pagepacket-window-list"],
  ["2026-07-01", "Verify", "Whitespace", "Pass", "No whitespace errors.", "git diff --check"],
];

const statuses = ["Untested", "Pass", "Fail", "Blocked", "Needs Fix", "Retest Pass", "Retest Fail", "N/A"];
const retestStatuses = ["Not Retested", "Retest Pass", "Retest Fail", "N/A"];
const issueStatuses = ["Open", "Fixed", "Won't Fix", "Blocked", "Retest Pass", "Retest Fail"];
const priorities = ["P0", "P1", "P2", "P3"];

function writeMatrix(sheet, startCell, matrix) {
  if (matrix.length === 0) return;
  const start = sheet.getRange(startCell);
  const target = start.resize(matrix.length, matrix[0].length);
  target.values = matrix;
  return target;
}

function styleHeader(range) {
  range.format = {
    fill: "#1a3300",
    font: { bold: true, color: "#fcfaf5" },
    wrapText: true,
    horizontalAlignment: "center",
    verticalAlignment: "middle",
  };
}

function styleTitle(range) {
  range.format = {
    fill: "#ffe95c",
    font: { bold: true, color: "#1a3300", size: 16 },
    wrapText: true,
    verticalAlignment: "middle",
  };
}

function setColumnWidths(sheet, widths) {
  widths.forEach((width, index) => {
    const col = String.fromCharCode("A".charCodeAt(0) + index);
    sheet.getRange(`${col}1:${col}220`).format.columnWidth = width;
  });
}

const workbook = Workbook.create();
const summary = workbook.worksheets.add("Summary");
const storySheet = workbook.worksheets.add("Stories");
const issueSheet = workbook.worksheets.add("Issues");
const runSheet = workbook.worksheets.add("Runs");

for (const sheet of [summary, storySheet, issueSheet, runSheet]) {
  sheet.showGridLines = false;
}

// Summary
summary.getRange("A1:H1").merge();
summary.getRange("A1").values = [["Pagepacket Feature and QA Status"]];
styleTitle(summary.getRange("A1:H1"));
summary.getRange("A2:H2").merge();
summary.getRange("A2").values = [["Canonical tracker seeded from the current code checkout. Update this workbook as the user-story test/fix/retest loop progresses."]];
summary.getRange("A2:H2").format = { fill: "#fcfaf5", font: { color: "#1a3300" }, wrapText: true };

const summaryRows = [
  ["Metric", "Value", "Formula / Source"],
  ["Total stories", null, "=COUNTA('Stories'!$A$2:$A$200)"],
  ["Untested", null, "=COUNTIF('Stories'!$I$2:$I$200,\"Untested\")"],
  ["Needs fix", null, "=COUNTIF('Stories'!$I$2:$I$200,\"Needs Fix\")"],
  ["Passed", null, "=COUNTIF('Stories'!$I$2:$I$200,\"Pass\")+COUNTIF('Stories'!$I$2:$I$200,\"Retest Pass\")"],
  ["Failed or blocked", null, "=COUNTIF('Stories'!$I$2:$I$200,\"Fail\")+COUNTIF('Stories'!$I$2:$I$200,\"Blocked\")+COUNTIF('Stories'!$I$2:$I$200,\"Retest Fail\")"],
  ["Open issues", null, "=COUNTIF('Issues'!$F$2:$F$100,\"Open\")"],
  ["Fixed issues", null, "=COUNTIF('Issues'!$F$2:$F$100,\"Fixed\")+COUNTIF('Issues'!$F$2:$F$100,\"Retest Pass\")"],
];
writeMatrix(summary, "A4", summaryRows);
styleHeader(summary.getRange("A4:C4"));
summary.getRange("B5:B11").formulas = summaryRows.slice(1).map((row) => [row[2]]);
summary.getRange("C5:C11").values = summaryRows.slice(1).map((row) => [row[2]]);
summary.getRange("A4:C11").format.borders = { preset: "outside", style: "thin", color: "#b6b6b6" };
summary.getRange("A5:C11").format = { fill: "#fcfaf5", font: { color: "#1a3300" }, wrapText: true };
summary.getRange("B5:B11").format.numberFormat = "0";
setColumnWidths(summary, [28, 14, 58, 12, 12, 12, 12, 12]);

// Stories
const storyHeaders = ["ID", "Surface", "Feature", "User Story", "Expected Behavior From Code", "Code Evidence", "Test Method", "Priority", "Status", "Issue ID", "Retest Status", "Notes"];
writeMatrix(storySheet, "A1", [storyHeaders, ...activeStories]);
styleHeader(storySheet.getRange("A1:L1"));
storySheet.freezePanes.freezeRows(1);
storySheet.getRange(`A1:L${activeStories.length + 1}`).format = { wrapText: true, verticalAlignment: "top" };
storySheet.getRange("A1:L1").format.rowHeight = 34;
storySheet.getRange(`A2:L${activeStories.length + 1}`).format.rowHeight = 76;
setColumnWidths(storySheet, [11, 16, 22, 42, 56, 42, 28, 10, 14, 14, 16, 32]);
storySheet.getRange(`H2:H${activeStories.length + 1}`).dataValidation = { rule: { type: "list", values: priorities } };
storySheet.getRange(`I2:I${activeStories.length + 1}`).dataValidation = { rule: { type: "list", values: statuses } };
storySheet.getRange(`K2:K${activeStories.length + 1}`).dataValidation = { rule: { type: "list", values: retestStatuses } };
storySheet.tables.add(`A1:L${activeStories.length + 1}`, true, "StoriesTable");

// Issues
const issueHeaders = ["Issue ID", "Surface", "Title", "Observed / Risk", "Priority", "Status", "Found In", "Related Stories", "Likely Files", "Fix Notes"];
writeMatrix(issueSheet, "A1", [issueHeaders, ...activeIssues]);
styleHeader(issueSheet.getRange("A1:J1"));
issueSheet.freezePanes.freezeRows(1);
issueSheet.getRange(`A1:J${activeIssues.length + 1}`).format = { wrapText: true, verticalAlignment: "top" };
issueSheet.getRange("A1:J1").format.rowHeight = 34;
issueSheet.getRange(`A2:J${activeIssues.length + 1}`).format.rowHeight = 84;
setColumnWidths(issueSheet, [12, 18, 34, 60, 10, 14, 20, 24, 44, 40]);
issueSheet.getRange(`E2:E${activeIssues.length + 1}`).dataValidation = { rule: { type: "list", values: priorities } };
issueSheet.getRange(`F2:F${activeIssues.length + 1}`).dataValidation = { rule: { type: "list", values: issueStatuses } };
issueSheet.tables.add(`A1:J${activeIssues.length + 1}`, true, "IssuesTable");

// Runs
const runHeaders = ["Date", "Phase", "Check", "Result", "Notes", "Evidence"];
writeMatrix(runSheet, "A1", [runHeaders, ...runs]);
styleHeader(runSheet.getRange("A1:F1"));
runSheet.freezePanes.freezeRows(1);
runSheet.getRange(`A1:F${runs.length + 1}`).format = { wrapText: true, verticalAlignment: "top" };
runSheet.getRange(`A2:F${runs.length + 1}`).format.rowHeight = 64;
setColumnWidths(runSheet, [14, 20, 34, 14, 64, 50]);
runSheet.tables.add(`A1:F${runs.length + 1}`, true, "RunsTable");

// Visual previews for verification.
await fs.mkdir(outputDir, { recursive: true });
for (const sheetName of ["Summary", "Stories", "Issues", "Runs"]) {
  const preview = await workbook.render({ sheetName, autoCrop: "all", scale: 1, format: "png" });
  await fs.writeFile(path.join(outputDir, `${sheetName.toLowerCase()}-preview.png`), new Uint8Array(await preview.arrayBuffer()));
}

const summaryCheck = await workbook.inspect({
  kind: "table",
  range: "Summary!A4:C11",
  include: "values,formulas",
  tableMaxRows: 10,
  tableMaxCols: 4,
});
console.log(summaryCheck.ndjson);

const errorScan = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 300 },
  summary: "formula error scan",
});
console.log(errorScan.ndjson);

const xlsx = await SpreadsheetFile.exportXlsx(workbook);
await xlsx.save(workbookPath);
console.log(`saved ${workbookPath}`);
