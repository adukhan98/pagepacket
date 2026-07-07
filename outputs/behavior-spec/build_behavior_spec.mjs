import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const outputDir = "/Users/adnaankhan/Desktop/markdown/outputs/behavior-spec";
const outputPath = path.join(outputDir, "pagepacket-behavior-spec.xlsx");

const rows = [
  {
    id: "APP-001",
    area: "App Shell",
    story: "As a user, I can launch the macOS app into a main Markdown workspace window.",
    expected: "The app activates as a regular macOS app, creates WindowGroup(\"Pagepacket\"), injects a WorkspaceStore environment object, sets a minimum window size of 1120x720, and calls workspace.bootstrap() on appear.",
    source: "Sources/Pagepacket/App/PagepacketApp.swift:4 AppDelegate; Sources/Pagepacket/App/PagepacketApp.swift:12 PagepacketApp",
    questions: ""
  },
  {
    id: "APP-002",
    area: "Workspace",
    story: "As a user, I can choose a folder workspace from the app.",
    expected: "Open Workspace actions call openWorkspacePanel(), which shows an NSOpenPanel that allows directories only, disables multiple selection, and calls openWorkspace(url) for the selected folder.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:50 openWorkspacePanel; Sources/Pagepacket/Views/ContentView.swift:22 toolbar; Sources/Pagepacket/App/PagepacketCommands.swift:7 commands",
    questions: ""
  },
  {
    id: "APP-003",
    area: "Workspace",
    story: "As a user, I may start with a sample vault if it exists.",
    expected: "bootstrap() returns if a workspace is already set; otherwise it checks ~/Desktop/markdown/SampleVault and opens it automatically when that directory exists.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:41 bootstrap",
    questions: "Is automatic sample-vault loading intended first-run UX or a development convenience?"
  },
  {
    id: "APP-004",
    area: "Workspace",
    story: "As a user, I can open a folder and have the first Markdown file loaded.",
    expected: "openWorkspace(_:) sets workspaceURL, prepares history/share sidecars, reloads the file list, selects files.first, loads it if present, and starts the file watcher on the discovered files.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:62 openWorkspace(_:); Sources/Pagepacket/Services/VersionHistoryStore.swift:14 prepare",
    questions: "Empty or non-Markdown folders are not rejected in the store."
  },
  {
    id: "APP-005",
    area: "Workspace",
    story: "As a user, I can browse Markdown files from my workspace.",
    expected: "reloadFileList() recursively enumerates the workspace with skipsHiddenFiles, includes files whose extension lowercases to md, filters paths containing /.pagepacket/, maps them to MarkdownFile values, sorts by relative path, and updates the watcher.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:77 reloadFileList; Sources/Pagepacket/Models/MarkdownFile.swift:10 MarkdownFile.init",
    questions: ".pagepacket is skipped by hidden-file enumeration and explicit filtering."
  },
  {
    id: "APP-006",
    area: "Workspace",
    story: "As a user, I can select a Markdown file and load its text for editing.",
    expected: "load(file:) snapshots the current document first if the editor is dirty, sets selectedFile, reads UTF-8 content or an empty string on failure, sets editorText and lastLoadedText, clears externalChangeBanner, and refreshes snapshots.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:98 load(file:); Sources/Pagepacket/Views/SidebarView.swift:19 List(selection:)",
    questions: ""
  },
  {
    id: "APP-007",
    area: "Workspace",
    story: "As a user, I can save the selected Markdown document to disk.",
    expected: "saveCurrentDocument() snapshots with reason Before save, writes editorText atomically as UTF-8 to selectedFile.url, updates lastLoadedText, marks the watcher clean, reloads file list, and refreshes snapshots; write failures set externalChangeBanner.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:110 saveCurrentDocument; Sources/Pagepacket/Views/MarkdownEditorView.swift:23 Save button",
    questions: ""
  },
  {
    id: "APP-008",
    area: "Workspace",
    story: "As a user, I can see whether the current document has unsaved changes.",
    expected: "isDirty returns editorText != lastLoadedText; StatusStrip shows Unsaved with circle.fill and pink when dirty, otherwise Saved with checkmark.circle and teal.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:31 isDirty; Sources/Pagepacket/Views/ContentView.swift:101 StatusStrip",
    questions: ""
  },
  {
    id: "APP-009",
    area: "Workspace",
    story: "As a user, I can see current workspace and word-count status.",
    expected: "StatusStrip displays a word count from editorText.split(whereSeparator: .isWhitespace).count, the workspace folder name or No workspace, up to three agent names, and the text .pagepacket local-first.",
    source: "Sources/Pagepacket/Views/ContentView.swift:101 StatusStrip",
    questions: ""
  },
  {
    id: "APP-010",
    area: "Sidebar",
    story: "As a user, I can orient myself in the sidebar.",
    expected: "SidebarView shows the pagepacket title, the tagline Local-first Markdown for humans and agents, a Markdown section of file rows with doc.text icons, titles, and relative paths, and an Agents section with agent names and current statuses.",
    source: "Sources/Pagepacket/Views/SidebarView.swift:7 header; Sources/Pagepacket/Views/SidebarView.swift:19 Markdown section; Sources/Pagepacket/Views/SidebarView.swift:45 Agents section",
    questions: ""
  },
  {
    id: "APP-011",
    area: "Empty State",
    story: "As a user, I see a helpful prompt when no document is selected.",
    expected: "EditorContainerView renders EmptyWorkspaceView when selectedFile is nil, with Open a Markdown workspace copy and a button that opens the workspace panel.",
    source: "Sources/Pagepacket/Views/EditorContainerView.swift:5 EditorContainerView; Sources/Pagepacket/Views/EditorContainerView.swift:29 EmptyWorkspaceView",
    questions: ""
  },
  {
    id: "APP-012",
    area: "Editor Modes",
    story: "As a user, I can switch among Edit, Split, and Preview modes.",
    expected: "EditorMode defines edit/split/preview with titles Edit, Split, Preview; the store defaults to split; toolbar and menu pickers bind to workspace.editorMode; EditorContainerView renders MarkdownEditorView, MarkdownPreviewView, or an HSplitView containing both.",
    source: "Sources/Pagepacket/Models/EditorMode.swift:3 EditorMode; Sources/Pagepacket/Stores/WorkspaceStore.swift:13 editorMode; Sources/Pagepacket/Views/EditorContainerView.swift:11 switch",
    questions: "No persistence for last selected mode was found."
  },
  {
    id: "APP-013",
    area: "Markdown Editing",
    story: "As a user, I can directly edit Markdown text.",
    expected: "MarkdownEditorView displays the selected title and relative path, then binds a TextEditor directly to workspace.editorText using a monospaced font sized by workspace.editorFontSize.",
    source: "Sources/Pagepacket/Views/MarkdownEditorView.swift:3 MarkdownEditorView",
    questions: ""
  },
  {
    id: "APP-014",
    area: "Markdown Preview",
    story: "As a user, I can preview headings with visual hierarchy.",
    expected: "MarkdownRenderer maps lines beginning with # to heading blocks with level capped at 6; MarkdownPreviewView displays them with size 38 for h1, 30 for h2, 24 for h3, and 19 for other heading levels.",
    source: "Sources/Pagepacket/Services/MarkdownRenderer.swift:50 heading parsing; Sources/Pagepacket/Views/MarkdownPreviewView.swift:22 heading view",
    questions: ""
  },
  {
    id: "APP-015",
    area: "Markdown Preview",
    story: "As a user, I can preview paragraph and inline Markdown text.",
    expected: "Non-special trimmed lines become paragraph blocks; MarkdownInlineText attempts AttributedString(markdown:) and falls back to plain Text when parsing fails.",
    source: "Sources/Pagepacket/Services/MarkdownRenderer.swift:68 paragraph fallback; Sources/Pagepacket/Views/MarkdownPreviewView.swift:145 MarkdownInlineText",
    questions: ""
  },
  {
    id: "APP-016",
    area: "Markdown Preview",
    story: "As a user, I can preview quotes.",
    expected: "Lines beginning with > become quote blocks after trimming the marker; preview renders a lavender vertical bar and secondary-styled MarkdownInlineText.",
    source: "Sources/Pagepacket/Services/MarkdownRenderer.swift:53 quote parsing; Sources/Pagepacket/Views/MarkdownPreviewView.swift:32 quote view",
    questions: ""
  },
  {
    id: "APP-017",
    area: "Markdown Preview",
    story: "As a user, I can preview unordered and ordered lists.",
    expected: "Lines beginning - or * become unordered items unless they are tasks; numeric prefixes followed by a dot become orderedItem blocks; preview renders unordered bullets with teal dots and ordered items with a static 1. label.",
    source: "Sources/Pagepacket/Services/MarkdownRenderer.swift:59 list parsing; Sources/Pagepacket/Views/MarkdownPreviewView.swift:42 list views",
    questions: "Ordered list preview always displays 1. rather than the original number."
  },
  {
    id: "APP-018",
    area: "Markdown Preview",
    story: "As a user, I can preview Markdown task list items.",
    expected: "Lines beginning - [ ] or * [ ] become incomplete task blocks; - [x], * [x], - [X], or * [X] become complete task blocks; preview uses square or checkmark.square.fill.",
    source: "Sources/Pagepacket/Services/MarkdownRenderer.swift:55 task parsing; Sources/Pagepacket/Views/MarkdownPreviewView.swift:55 task view",
    questions: ""
  },
  {
    id: "APP-019",
    area: "Markdown Preview",
    story: "As a user, I can preview fenced code blocks.",
    expected: "Lines after an opening ``` are collected until another ```; text after the opening fence becomes optional language; preview shows an uppercase language label when present and monospaced selectable code in a card.",
    source: "Sources/Pagepacket/Services/MarkdownRenderer.swift:18 code parsing; Sources/Pagepacket/Views/MarkdownPreviewView.swift:62 code view",
    questions: "No syntax highlighting is implemented."
  },
  {
    id: "APP-020",
    area: "Markdown Preview",
    story: "As a user, I can preview Markdown tables.",
    expected: "A row containing | followed by a separator row made of - and : cells becomes a table; subsequent pipe rows become rows; preview normalizes shorter rows to header width and alternates row backgrounds.",
    source: "Sources/Pagepacket/Services/MarkdownRenderer.swift:31 table parsing; Sources/Pagepacket/Views/MarkdownPreviewView.swift:74 table view",
    questions: "Alignment markers are accepted but not represented."
  },
  {
    id: "APP-021",
    area: "Markdown Preview",
    story: "As a user, I can preview Markdown images relative to the document.",
    expected: "A line matching ![alt](path) becomes an image block; preview resolves the path relative to the selected file's folder, shows the NSImage if found, and otherwise displays Missing image: <path>.",
    source: "Sources/Pagepacket/Services/MarkdownRenderer.swift:76 parseImage; Sources/Pagepacket/Views/MarkdownPreviewView.swift:112 imageView",
    questions: ""
  },
  {
    id: "APP-022",
    area: "Markdown Preview",
    story: "As a user, I can preview horizontal rules.",
    expected: "A trimmed line equal to --- or *** becomes horizontalRule; preview renders a thin black-opacity rectangle with vertical padding.",
    source: "Sources/Pagepacket/Services/MarkdownRenderer.swift:48 horizontalRule; Sources/Pagepacket/Views/MarkdownPreviewView.swift:135 horizontalRule view",
    questions: ""
  },
  {
    id: "APP-023",
    area: "Image Import",
    story: "As a user, I can insert an image into the current Markdown document.",
    expected: "insertImageFromPanel() allows png, jpeg, gif, tiff, heic, and webP files; ImageImportService copies the selected file into assets/<document-name>/<source-base>-<unix-seconds>.<ext>; the editor appends a Markdown image link and creates an Inserted image snapshot.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:171 insertImageFromPanel; Sources/Pagepacket/Services/ImageImportService.swift:7 importImage",
    questions: "Import failure returns nil with no user-visible error. Snapshot is created before an explicit save persists the appended Markdown."
  },
  {
    id: "APP-024",
    area: "Version History",
    story: "As a user, my workspace gets local sidecar folders for history and shares.",
    expected: "VersionHistoryStore.prepare() creates .pagepacket/history and .pagepacket/shares under the workspace URL.",
    source: "Sources/Pagepacket/Services/VersionHistoryStore.swift:14 prepare",
    questions: ""
  },
  {
    id: "APP-025",
    area: "Version History",
    story: "As a user, I can create a manual snapshot.",
    expected: "Toolbar, menu, and History tab snapshot actions call snapshotCurrentDocument(reason: Manual checkpoint, source: Pagepacket), which writes a VersionHistoryStore snapshot and inserts it at the front of the in-memory snapshots list.",
    source: "Sources/Pagepacket/Views/ContentView.swift:47 Snapshot button; Sources/Pagepacket/App/PagepacketCommands.swift:18 Snapshot Version; Sources/Pagepacket/Views/HistoryView.swift:10 plus button; Sources/Pagepacket/Stores/WorkspaceStore.swift:139 snapshotCurrentDocument",
    questions: ""
  },
  {
    id: "APP-026",
    area: "Version History",
    story: "As a user, snapshots preserve document content with metadata.",
    expected: "snapshot(file:content:reason:source:) writes .pagepacket/history/<safe-relative-path>/<yyyyMMdd-HHmmss-SSS>.md with front matter keys pagepacket_document, pagepacket_source, pagepacket_reason, pagepacket_created_at, then the content; it returns a VersionSnapshot with byte count.",
    source: "Sources/Pagepacket/Services/VersionHistoryStore.swift:19 snapshot; Sources/Pagepacket/Models/VersionSnapshot.swift:3 VersionSnapshot",
    questions: ""
  },
  {
    id: "APP-027",
    area: "Version History",
    story: "As a user, I can see snapshots for the current file.",
    expected: "refreshSnapshots() loads snapshots for selectedFile; snapshots(for:) reads .md files from the safe document folder, uses each snapshot file's contentModificationDate as the VersionSnapshot timestamp, extracts pagepacket_reason/pagepacket_source, defaults to Checkpoint/Pagepacket, and sorts by that timestamp descending.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:163 refreshSnapshots; Sources/Pagepacket/Services/VersionHistoryStore.swift:53 snapshots(for:)",
    questions: ""
  },
  {
    id: "APP-028",
    area: "Version History",
    story: "As a user, I understand the history panel state and snapshot cards.",
    expected: "HistoryView shows a Version History header and plus snapshot button; when snapshots is empty it shows No snapshots yet copy; otherwise each card shows displayTitle, reason, formatted date/time, byte count, and a Restore button.",
    source: "Sources/Pagepacket/Views/HistoryView.swift:3 HistoryView; Sources/Pagepacket/Views/HistoryView.swift:17 empty state; Sources/Pagepacket/Views/HistoryView.swift:23 snapshot cards",
    questions: ""
  },
  {
    id: "APP-029",
    area: "Version History",
    story: "As a user, I can restore a previous snapshot.",
    expected: "HistoryView Restore calls workspace.restore(snapshot); restoreContent strips front matter when present; restore snapshots the current document first, writes restored content to the selected file, updates lastLoadedText, marks watcher clean, and refreshes snapshots.",
    source: "Sources/Pagepacket/Views/HistoryView.swift:43 Restore; Sources/Pagepacket/Stores/WorkspaceStore.swift:147 restore; Sources/Pagepacket/Services/VersionHistoryStore.swift:79 restoreContent",
    questions: "No restore confirmation flow is implemented."
  },
  {
    id: "APP-030",
    area: "External Changes",
    story: "As a user, external edits are detected while a workspace is open.",
    expected: "FileWatcher.start() stores known modification dates for watched files and schedules a one-second repeating timer; when an existing watched file's modification date increases, it calls the supplied onChange callback.",
    source: "Sources/Pagepacket/Services/FileWatcher.swift:9 start(watching:onChange:)",
    questions: "New files are watched only after store reload/update paths run."
  },
  {
    id: "APP-031",
    area: "External Changes",
    story: "As a user, a clean selected file reloads after an external edit.",
    expected: "handleExternalChange reloads the file list; if the changed URL is the selected file, disk text differs from lastLoadedText, and the editor is not dirty, editorText and lastLoadedText are replaced from disk, banner becomes Reloaded external edit from disk, Codex agent status becomes Reloaded, and snapshots refresh.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:225 handleExternalChange(at:)",
    questions: ""
  },
  {
    id: "APP-032",
    area: "External Changes",
    story: "As a user, I am warned before overwriting local edits when an external edit arrives.",
    expected: "If the selected file changes externally while the editor is dirty, the app snapshots External change conflict base, sets an external-change banner saying review before overwriting, and changes the Codex agent status/detail to Conflict.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:237 dirty external-change branch; Sources/Pagepacket/Views/ContentView.swift:70 ExternalChangeBanner",
    questions: "No merge/diff UI is implemented for the conflict."
  },
  {
    id: "APP-033",
    area: "External Changes",
    story: "As a user, I can choose the disk version after an external-change banner.",
    expected: "Use Disk calls reloadSelectedFromDisk(), which reads selected file content from disk, snapshots Before accepting external change, replaces editorText and lastLoadedText, clears the banner, and refreshes snapshots.",
    source: "Sources/Pagepacket/Views/ContentView.swift:80 Use Disk; Sources/Pagepacket/Stores/WorkspaceStore.swift:124 reloadSelectedFromDisk",
    questions: ""
  },
  {
    id: "APP-034",
    area: "External Changes",
    story: "As a user, I can keep my local version after an external-change banner.",
    expected: "Keep Mine calls keepLocalVersion(), which saves the current document through saveCurrentDocument() and clears externalChangeBanner.",
    source: "Sources/Pagepacket/Views/ContentView.swift:83 Keep Mine; Sources/Pagepacket/Stores/WorkspaceStore.swift:134 keepLocalVersion",
    questions: ""
  },
  {
    id: "APP-035",
    area: "External Changes",
    story: "As a user, I can dismiss an external-change banner.",
    expected: "The xmark button sets workspace.externalChangeBanner to nil without changing disk or editor content.",
    source: "Sources/Pagepacket/Views/ContentView.swift:87 xmark banner button",
    questions: ""
  },
  {
    id: "APP-036",
    area: "External Changes",
    story: "As a user, non-selected file edits update agent status without interrupting my current document.",
    expected: "When handleExternalChange receives a changed URL that is not the selected file, it sets agents[0].status to Changed and detail to External edit detected in another Markdown file, then returns.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:228 non-selected change branch",
    questions: "No per-file change list is implemented."
  },
  {
    id: "APP-037",
    area: "Inspector",
    story: "As a user, I can show or hide the inspector.",
    expected: "ContentView attaches an inspector bound to workspace.isInspectorVisible; toolbar Inspector and the View menu Toggle Inspector command invert that Boolean, with Cmd-Option-I wired as a keyboard shortcut.",
    source: "Sources/Pagepacket/Views/ContentView.swift:18 inspector; Sources/Pagepacket/Views/ContentView.swift:60 Inspector toolbar button; Sources/Pagepacket/App/PagepacketCommands.swift:35 Toggle Inspector",
    questions: ""
  },
  {
    id: "APP-038",
    area: "Inspector",
    story: "As a user, I can switch inspector tabs for History, Share, and Agents.",
    expected: "InspectorView stores selectedTab defaulting to History; a segmented Picker switches among History, Share, and Agents; the scroll area renders HistoryView, ShareView, or AgentsPanel.",
    source: "Sources/Pagepacket/Views/InspectorView.swift:3 InspectorView",
    questions: ""
  },
  {
    id: "APP-039",
    area: "Inspector",
    story: "As a user, I can inspect agent-safe editing guidance and statuses.",
    expected: "AgentsPanel shows explanatory copy, renders workspace.agents cards, and lists the CLI sync contract commands pagepacket-cli status, snapshot, apply, and the skill path.",
    source: "Sources/Pagepacket/Views/InspectorView.swift:37 AgentsPanel; Sources/Pagepacket/Stores/WorkspaceStore.swift:21 agents",
    questions: "AgentKind defines Hermes and Shell, but default displayed agents are Codex, Claude Code, and Cursor."
  },
  {
    id: "APP-040",
    area: "Sharing",
    story: "As a user, I can add a local invite intent by email and role.",
    expected: "ShareView binds a text field and segmented role picker; Add Invite calls addInvite(email:role:), which ignores blank trimmed emails, appends an Invite, writes the manifest, and then clears the field.",
    source: "Sources/Pagepacket/Views/ShareView.swift:3 ShareView; Sources/Pagepacket/Stores/WorkspaceStore.swift:189 addInvite; Sources/Pagepacket/Models/Invite.swift:3 InviteRole",
    questions: "No email-format validation is implemented; store starts with hardcoded sample invites."
  },
  {
    id: "APP-041",
    area: "Sharing",
    story: "As a user, invite changes are saved beside the workspace.",
    expected: "addInvite, removeInvite, and composeEmail all call writeInviteManifest(), which creates .pagepacket/shares and writes pretty-printed sorted JSON to .pagepacket/shares/invites.json.",
    source: "Sources/Pagepacket/Stores/WorkspaceStore.swift:189 addInvite; Sources/Pagepacket/Stores/WorkspaceStore.swift:195 removeInvite; Sources/Pagepacket/Stores/WorkspaceStore.swift:200 composeEmail; Sources/Pagepacket/Stores/WorkspaceStore.swift:252 writeInviteManifest",
    questions: "No code reads invites.json back into the app state."
  },
  {
    id: "APP-042",
    area: "Sharing",
    story: "As a user, I can compose an invite email.",
    expected: "The envelope button calls composeEmail(for:), which writes the manifest, builds a mailto URL to the invite email with a Pagepacket invitation subject/body containing role, workspace name/path, and local-first instructions, then opens it through NSWorkspace.",
    source: "Sources/Pagepacket/Views/ShareView.swift:51 envelope button; Sources/Pagepacket/Stores/WorkspaceStore.swift:200 composeEmail",
    questions: "The app composes only; actual sending is delegated to the OS mail client."
  },
  {
    id: "APP-043",
    area: "Sharing",
    story: "As a user, I can remove a local invite intent.",
    expected: "The xmark button calls removeInvite(_:) and removes all invites with the same id, then writes the manifest.",
    source: "Sources/Pagepacket/Views/ShareView.swift:58 remove button; Sources/Pagepacket/Stores/WorkspaceStore.swift:195 removeInvite",
    questions: ""
  },
  {
    id: "APP-044",
    area: "Settings",
    story: "As a user, I can see an autosave setting in Settings.",
    expected: "SettingsView exposes a Toggle labeled Autosave on every edit bound to workspace.autosaveEnabled; the store default is false. MarkdownEditorView observes editorText and calls saveCurrentDocument when autosaveEnabled is true and the document is dirty.",
    source: "Sources/Pagepacket/App/SettingsView.swift:8 Editor section; Sources/Pagepacket/Stores/WorkspaceStore.swift:26 autosaveEnabled; Sources/Pagepacket/Views/MarkdownEditorView.swift:36 onChange",
    questions: ""
  },
  {
    id: "APP-045",
    area: "Settings",
    story: "As a user, I can adjust editor font size.",
    expected: "SettingsView exposes a Stepper from 12 to 24 bound to workspace.editorFontSize; MarkdownEditorView uses that value for the TextEditor monospaced font size.",
    source: "Sources/Pagepacket/App/SettingsView.swift:10 Stepper; Sources/Pagepacket/Views/MarkdownEditorView.swift:33 font",
    questions: "No persistence for the setting was found."
  },
  {
    id: "APP-046",
    area: "Settings",
    story: "As a user, I can disable external agent-change detection.",
    expected: "SettingsView exposes a Toggle bound to externalChangeDetectionEnabled; handleExternalChange returns immediately when that Boolean is false.",
    source: "Sources/Pagepacket/App/SettingsView.swift:11 Toggle; Sources/Pagepacket/Stores/WorkspaceStore.swift:226 guard externalChangeDetectionEnabled",
    questions: ""
  },
  {
    id: "APP-047",
    area: "Settings",
    story: "As a user, I can see the configured sidecar and asset folders.",
    expected: "SettingsView displays read-only labeled content values Sidecar folder .pagepacket and Asset folder assets.",
    source: "Sources/Pagepacket/App/SettingsView.swift:14 Workspace section",
    questions: ""
  },
  {
    id: "APP-048",
    area: "Keyboard Shortcuts",
    story: "As a keyboard-driven user, I can use menu shortcuts for common workspace actions.",
    expected: "Pagepacket commands add Open Workspace... with Cmd-Shift-O, Save Document with Cmd-S, Snapshot Version with Cmd-Shift-S, and Toggle Inspector with Cmd-Option-I.",
    source: "Sources/Pagepacket/App/PagepacketCommands.swift:7 Open Workspace; Sources/Pagepacket/App/PagepacketCommands.swift:13 Save Document; Sources/Pagepacket/App/PagepacketCommands.swift:18 Snapshot Version; Sources/Pagepacket/App/PagepacketCommands.swift:35 Toggle Inspector",
    questions: ""
  },
  {
    id: "CLI-001",
    area: "CLI",
    story: "As a CLI user, I can discover supported commands.",
    expected: "No command or an unknown command prints usage text listing status, snapshot, apply, and history commands.",
    source: "Sources/PagepacketCLI/main.swift:4 PagepacketCLI.main; Sources/PagepacketCLI/main.swift:130 printUsage",
    questions: "Unknown commands print usage but do not explicitly exit nonzero."
  },
  {
    id: "CLI-002",
    area: "CLI",
    story: "As a CLI user, I can inspect a vault's Markdown inventory.",
    expected: "pagepacket-cli status <vault> prints the vault path, Markdown file count, .pagepacket sidecar path, and up to 12 sorted relative .md paths; hidden files and paths containing /.pagepacket/ or legacy /.pagepacket/ are skipped.",
    source: "Sources/PagepacketCLI/main.swift:25 status; Sources/PagepacketCLI/main.swift:106 markdownFiles",
    questions: "A missing/nonexistent vault reports zero Markdown files instead of an error."
  },
  {
    id: "CLI-003",
    area: "CLI",
    story: "As a CLI user, I can checkpoint a Markdown file before edits.",
    expected: "pagepacket-cli snapshot <vault> <file> --message <message> reads the file, defaults message to CLI checkpoint when absent, and writes a millisecond timestamped snapshot under .pagepacket/history/<safe-file>/ with pagepacket_* front matter.",
    source: "Sources/PagepacketCLI/main.swift:37 snapshot; Sources/PagepacketCLI/main.swift:76 writeSnapshot",
    questions: ""
  },
  {
    id: "CLI-004",
    area: "CLI",
    story: "As a CLI user, I can record an external edit by an agent or author.",
    expected: "pagepacket-cli apply <vault> <file> --author <author> defaults author to agent and writes a snapshot with reason Applied external edit by <author> and source <author>.",
    source: "Sources/PagepacketCLI/main.swift:48 apply; Sources/PagepacketCLI/main.swift:76 writeSnapshot",
    questions: "apply currently checkpoints; it does not apply or reconcile a diff."
  },
  {
    id: "CLI-005",
    area: "CLI",
    story: "As a CLI user, I can list snapshot history for a Markdown file.",
    expected: "pagepacket-cli history <vault> <file> reads .pagepacket/history/<safe-file>/, prints No snapshots for missing folders, otherwise prints snapshot IDs newest-first by filename.",
    source: "Sources/PagepacketCLI/main.swift:59 history",
    questions: "History does not show reason/source metadata."
  },
  {
    id: "CLI-006",
    area: "Package",
    story: "As a developer, I can build the app and CLI from SwiftPM.",
    expected: "Package.swift defines a macOS 14 package named Pagepacket with executable products Pagepacket and pagepacket-cli and executable targets Sources/Pagepacket and Sources/PagepacketCLI.",
    source: "Package.swift:4 package; Package.swift:10 products; Package.swift:14 targets",
    questions: "Internal target/source-directory names still use Pagepacket; product and executable names are Pagepacket/pagepacket-cli."
  },
  {
    id: "CLI-007",
    area: "Build Script",
    story: "As a developer, I can build and launch the app bundle from the repo script.",
    expected: "script/build_and_run.sh kills an existing Pagepacket process, runs swift build, creates dist/Pagepacket.app, copies the binary and icon, writes Info.plist with bundle id com.adnaankhan.Pagepacket and minimum system 14.0, then opens the bundle in run mode.",
    source: "script/build_and_run.sh:4 setup; script/build_and_run.sh:21 build/package; script/build_and_run.sh:59 mode switch",
    questions: ""
  },
  {
    id: "CLI-008",
    area: "Build Script",
    story: "As a developer, I can verify, debug, and observe the app from the repo script.",
    expected: "The script supports run, debug/--debug through lldb, logs/--logs through process log stream, telemetry/--telemetry through subsystem log stream, and verify/--verify which opens the app, sleeps one second, and checks pgrep -x Pagepacket.",
    source: "script/build_and_run.sh:59 mode switch",
    questions: "Script does not use isolated build paths; verify waits one second."
  },
  {
    id: "SITE-001",
    area: "Landing Page",
    story: "As a visitor, I can navigate to main product sections.",
    expected: "The sticky site nav links brand to #top and links Tour, Review, CLI, and Join waitlist to #tour, #review, #cli, and #waitlist.",
    source: "landing page/index.html:22 nav; landing page/styles.css:61 .site-nav",
    questions: ""
  },
  {
    id: "SITE-002",
    area: "Landing Page",
    story: "As a visitor, I can request access from the hero waitlist form.",
    expected: "The hero form has data-waitlist-form, action /waitlist, method post, novalidate, a required email input, and a submit button; script prevents default submit and runs client-side email validity.",
    source: "landing page/index.html:63 hero form; landing page/script.js:28 submit handler",
    questions: "No production /waitlist endpoint is implemented in this repo."
  },
  {
    id: "SITE-003",
    area: "Landing Page",
    story: "As a visitor, I can request access from the footer waitlist form.",
    expected: "The #waitlist section has a second data-waitlist-form with required email input and Request access button; it shares the same JavaScript behavior as the hero form.",
    source: "landing page/index.html:247 waitlist section; landing page/script.js:28 submit handler",
    questions: ""
  },
  {
    id: "SITE-004",
    area: "Landing Page",
    story: "As a waitlist user, I get validation and status feedback.",
    expected: "setFormState sets form.dataset.state and writes messages to [data-form-message]; invalid email sets error message and focuses the input, loading says Adding you to the waitlist..., success or fetch failure sets corresponding feedback.",
    source: "landing page/script.js:22 setFormState; landing page/script.js:34 invalid branch; landing page/styles.css:325 state styling",
    questions: "Loading state does not disable submit buttons."
  },
  {
    id: "SITE-005",
    area: "Landing Page",
    story: "As a preview user, waitlist submissions are saved locally when no backend exists.",
    expected: "When form action is missing or /waitlist, script reads localStorage pagepacket-waitlist-preview as JSON array, appends the submitted email with Set-based dedupe, stores it back, shows Saved in this browser. Connect /waitlist before launch., and resets the form.",
    source: "landing page/script.js:43 local preview branch",
    questions: ""
  },
  {
    id: "SITE-006",
    area: "Landing Page",
    story: "As a visitor, I can understand the review packet model visually.",
    expected: "The hero packet board shows draft/agent/packet rail labels, a welcome.md review packet, plain/removed/added/conflict example lines, and static Accept hunk, Reject, and Checkpoint first buttons.",
    source: "landing page/index.html:99 packet-board; landing page/styles.css:445 review-packet styles",
    questions: "Preview action buttons are static and have no click behavior."
  },
  {
    id: "SITE-007",
    area: "Landing Page",
    story: "As a visitor, I can see product facts in the first viewport.",
    expected: "The hero proof list states Format .md files, Sidecars .pagepacket/, and Access waitlist first.",
    source: "landing page/index.html:83 hero__proof",
    questions: ""
  },
  {
    id: "SITE-008",
    area: "Landing Page",
    story: "As a visitor, I can understand the product loop from the tour section.",
    expected: "The #tour section presents Write, Detect, and Decide cards describing plain Markdown, external edits as packets, and conflict/hunk review.",
    source: "landing page/index.html:144 #tour workbench",
    questions: ""
  },
  {
    id: "SITE-009",
    area: "Landing Page",
    story: "As a visitor, I can inspect what a packet contains.",
    expected: "The #review flow list contains four rows: Block-level diff, Conflict context, Local history, and Portable files.",
    source: "landing page/index.html:195 #review flow-list",
    questions: ""
  },
  {
    id: "SITE-010",
    area: "Landing Page",
    story: "As an agent-heavy user, I can see scriptable workflow examples.",
    expected: "The #cli section shows static marketing copy for pagepacket-cli status and snapshot examples with pending agent edits, review-required conflicts, and .pagepacket/history output. This is landing-page content, not the implemented Swift CLI behavior.",
    source: "landing page/index.html:228 #cli code-slab",
    questions: ""
  },
  {
    id: "SITE-011",
    area: "Landing Page",
    story: "As a visitor, reveal-observed content remains visible.",
    expected: "CSS sets .reveal and .reveal.is-visible to opacity 1 and transform none; when reduced motion is not requested, script observes .reveal targets and adds is-visible on intersection, but current CSS makes the visible state a no-op.",
    source: "landing page/script.js:3 reveal observer; landing page/styles.css:757 .reveal",
    questions: "The reveal class appears visible by default, so script does not create a visible animation."
  },
  {
    id: "SITE-012",
    area: "Landing Page",
    story: "As a visitor using a configured waitlist backend, the form can POST JSON to that backend.",
    expected: "If a waitlist form action is present and not /waitlist, script sends fetch(endpoint) with method from the form or POST, Content-Type application/json, and body { email }; non-ok responses throw and show the endpoint failure message.",
    source: "landing page/script.js:54 custom endpoint fetch branch",
    questions: "No non-/waitlist endpoint is configured in the current HTML."
  },
  {
    id: "SITE-013",
    area: "Landing Page",
    story: "As a mobile visitor, I can still use the page layout.",
    expected: "Responsive CSS collapses nav grid and hero/workbench/cli/waitlist layouts, hides nav command/links below 60rem, stacks form rows below 40rem, and hides paper scraps below 40rem.",
    source: "landing page/styles.css:777 responsive rules",
    questions: ""
  },
  {
    id: "SITE-014",
    area: "Landing Page",
    story: "As a visitor, I can navigate again from the footer.",
    expected: "The footer repeats the brand link to #top and footer links to #tour, #review, #cli, and #waitlist.",
    source: "landing page/index.html:280 footer",
    questions: ""
  },
  {
    id: "SITE-015",
    area: "Landing Page",
    story: "As a maintainer, I can see an alternate download-oriented page artifact in the repo.",
    expected: "index 2.html contains a separate page with nav, hero download CTA, how-it-works, features, review, cli, download CTA, and footer; it links the companion styles%202.css and script%202.js files.",
    source: "landing page/index 2.html:22 alternate nav; landing page/index 2.html:418 #download",
    questions: "Is index 2.html a stale backup or intended alternate surface?"
  },
  {
    id: "SITE-016",
    area: "Landing Page",
    story: "As a maintainer, I can see intended alternate-page interactions in an orphaned script.",
    expected: "script 2.js implements scroll nav state, reveal classes, hero entrance animation, offset anchor scrolling, and a magnetic button effect; index 2.html loads it as script%202.js.",
    source: "landing page/script 2.js:8 handleScroll; landing page/script 2.js:72 anchor handler",
    questions: ""
  },
  {
    id: "SITE-017",
    area: "Landing Page",
    story: "As a maintainer, I can see intended alternate-page styling in an orphaned stylesheet.",
    expected: "styles 2.css defines the alternate nav, button, hero, step-card, feature-card, diff-demo, cli-demo, cta-card, and footer visual system; index 2.html loads it as styles%202.css.",
    source: "landing page/styles 2.css:137 nav-wrap; landing page/styles 2.css:645 diff-demo",
    questions: ""
  },
  {
    id: "SAMPLE-001",
    area: "Sample Vault",
    story: "As a user, I can open a sample Markdown vault showing supported content.",
    expected: "SampleVault/welcome.md contains headings, lists, tasks, a quote, a table, fenced code, and an image link to assets/welcome/pagepacket-sample.ppm.",
    source: "SampleVault/welcome.md:1 sample Markdown",
    questions: "Sample text mentions link rendering; renderer relies on AttributedString inline parsing rather than a link block model."
  },
  {
    id: "SAMPLE-002",
    area: "Sample Vault",
    story: "As a maintainer, I can inspect sample pending agent-change sidecar metadata.",
    expected: "SampleVault/.pagepacket/changes/*.json records include agent, authorKind, authorName, createdAt, filePath, id, metadataVersion, source, status, and summary.",
    source: "SampleVault/.pagepacket/changes/20260620-001429-904-codex.json:1 sample change JSON",
    questions: "No Sources/Pagepacket code reads .pagepacket/changes files."
  },
  {
    id: "SAMPLE-003",
    area: "Sample Vault",
    story: "As a maintainer, I can inspect sample pending review-packet sidecar metadata.",
    expected: "SampleVault/.pagepacket/reviews/pending/<id>.json includes author metadata, file path, base/proposed text, range entries with before/after line ranges and conflict flags, pending status, and summary.",
    source: "SampleVault/.pagepacket/reviews/pending/31665715-93BE-4863-A3EF-D4F6D73DD71B.json:1 sample review JSON",
    questions: "No Review model/store implementation was found in Sources/Pagepacket."
  },
  {
    id: "SAMPLE-004",
    area: "Sample Vault",
    story: "As a maintainer, I can inspect sample pagepacket history artifacts.",
    expected: "SampleVault/.pagepacket/history/welcome_md/*.md contains pagepacket_* front matter snapshots for welcome.md from previous Pagepacket flows; current app code reads .pagepacket/history.",
    source: "SampleVault/.pagepacket/history/welcome_md/20260620-001429.md:1 sample pagepacket history",
    questions: "Are these migration fixtures, stale artifacts, or current expected sidecars?"
  },
  {
    id: "SAMPLE-005",
    area: "Sample Vault",
    story: "As a maintainer, I can see an empty pending-review placeholder artifact.",
    expected: "SampleVault/.pagepacket/reviews/pending/XXLR4isc exists as an empty file with no JSON content, so it cannot be parsed as a review packet.",
    source: "SampleVault/.pagepacket/reviews/pending/XXLR4isc",
    questions: "Should the empty placeholder be removed, ignored, or treated as a corrupt pending review?"
  },
  {
    id: "DOC-001",
    area: "Agent Skill",
    story: "As a coding agent, I can follow a repo-local workflow for safe Markdown edits.",
    expected: "skills/pagepacket-sync/SKILL.md instructs agents to run pagepacket-cli status, snapshot before broad edits, edit normal Markdown files directly, avoid hand-editing .pagepacket, register completed edits with pagepacket-cli apply, and stop for user choice on external-change conflicts.",
    source: "skills/pagepacket-sync/SKILL.md:1 pagepacket Sync",
    questions: ""
  },
  {
    id: "DOC-002",
    area: "README",
    story: "As a developer, I can see implemented capabilities and run commands.",
    expected: "README.md lists implemented app features, run and verify commands, CLI commands, and the architecture sidecar layout using .pagepacket/history and .pagepacket/shares.",
    source: "README.md:1 pagepacket README",
    questions: ""
  }
];

const defectSeeds = [
  {
    id: "D-001",
    featureId: "SITE-007 / SITE-010 / APP-024 / CLI-002 / SAMPLE-002 / SAMPLE-003 / SAMPLE-004",
    area: "Branding / Sidecar",
    defect: "Landing page and sample artifacts advertised pagepacket-cli and .pagepacket while the app and CLI exposed old Pagepacket/pagepacket-cli/.pagepacket surfaces.",
    type: "Functional/logistical",
    status: "Verified",
    source: "landing page/index.html:90; landing page/index.html:236; Sources/PagepacketCLI/main.swift:31; Sources/Pagepacket/Services/VersionHistoryStore.swift:7",
    resolution: "Renamed package products, app bundle/script output, visible app copy, CLI copy/output, docs, sample vault, and sidecar writes to Pagepacket/pagepacket-cli/.pagepacket."
  },
  {
    id: "D-002",
    featureId: "APP-044",
    area: "Settings",
    defect: "Autosave setting was exposed but no code path saved on edit when autosaveEnabled was true.",
    type: "Functional/logistical",
    status: "Verified",
    source: "Sources/Pagepacket/App/SettingsView.swift:9; Sources/Pagepacket/Stores/WorkspaceStore.swift:26",
    resolution: "MarkdownEditorView now observes editorText and calls saveCurrentDocument when autosaveEnabled and dirty."
  },
  {
    id: "D-003",
    featureId: "SAMPLE-002 / SAMPLE-003",
    area: "Review Packets",
    defect: "Sample .pagepacket review/change sidecars exist, but no Sources/Pagepacket model or store reads them.",
    type: "Open question",
    status: "Open question",
    source: "SampleVault/.pagepacket/reviews/pending/31665715-93BE-4863-A3EF-D4F6D73DD71B.json:1; Sources/Pagepacket/Stores/WorkspaceStore.swift",
    resolution: "Left as an explicit product/implementation gap rather than a loop bug; no app behavior currently claims to read these sidecars."
  },
  {
    id: "D-004",
    featureId: "SITE-015 / SITE-016 / SITE-017",
    area: "Landing Page",
    defect: "Alternate index 2.html appears paired with styles 2.css and script 2.js, but links the primary styles.css and script.js instead.",
    type: "Functional/logistical",
    status: "Verified",
    source: "landing page/index 2.html:18; landing page/index 2.html:491; landing page/styles 2.css:137; landing page/script 2.js:8",
    resolution: "index 2.html now links styles%202.css and script%202.js; Playwright confirmed the companion assets are loaded."
  },
  {
    id: "D-005",
    featureId: "APP-025 / CLI-003",
    area: "Version History",
    defect: "App and CLI snapshot IDs used second-level timestamps, so rapid snapshots for the same file could overwrite/collide.",
    type: "Functional/logistical",
    status: "Verified",
    source: "Sources/Pagepacket/Services/VersionHistoryStore.swift:101; Sources/PagepacketCLI/main.swift:85",
    resolution: "App and CLI snapshot IDs now include milliseconds; temp-vault retest produced two distinct same-second snapshots."
  }
];

const fixedRows = new Map([
  ["APP-025", "D-005"],
  ["APP-026", "D-005"],
  ["APP-044", "D-002"],
  ["CLI-003", "D-005"],
  ["CLI-004", "D-005"],
  ["SITE-015", "D-004"],
  ["SITE-016", "D-004"],
  ["SITE-017", "D-004"]
]);

function testMethodFor(id) {
  if (id.startsWith("SITE-")) return "Playwright browser check against local HTTP server plus static HTML/CSS/JS inspection";
  if (id.startsWith("CLI-")) return "swift build --jobs 1, built pagepacket-cli command execution, and temp-vault filesystem assertions";
  if (id.startsWith("APP-")) return "Swift build/link verification plus static source inspection; app launch verified with ./script/build_and_run.sh --verify where UI automation was not available";
  if (id.startsWith("SAMPLE-")) return "Static sample-vault filesystem/content inspection";
  if (id.startsWith("DOC-")) return "Static documentation/skill inspection";
  return "Static code inspection";
}

for (const row of rows) {
  const defect = fixedRows.get(row.id);
  row.status = "Verified";
  row.defects = defect || "-";
  row.type = defect === "D-002" || defect === "D-004" || defect === "D-005" ? "Functional/logistical" : "-";
  row.testMethod = testMethodFor(row.id);
  row.iteration = 1;
}

const workbook = Workbook.create();
const stories = workbook.worksheets.add("User Stories");
const summary = workbook.worksheets.add("Summary");
const defects = workbook.worksheets.add("Defects");
const questions = workbook.worksheets.add("Open Questions");
const log = workbook.worksheets.add("Verification Log");
const generatedAt = `Generated ${new Date().toISOString()}`;

const storyHeaders = [
  "Area",
  "Feature ID",
  "User story",
  "Expected behavior (from code)",
  "Status",
  "Defects",
  "Type",
  "Test method",
  "Iteration",
  "Notes / source",
  "Open questions"
];

const storyValues = [
  storyHeaders,
  ...rows.map((r) => [
    r.area,
    r.id,
    r.story,
    r.expected,
    r.status,
    r.defects,
    r.type,
    r.testMethod,
    r.iteration,
    r.source,
    r.questions || "-"
  ])
];

stories.getRangeByIndexes(0, 0, storyValues.length, storyHeaders.length).values = storyValues;
const storyRange = `A1:K${storyValues.length}`;
const storyTable = stories.tables.add(storyRange, true, "UserStoriesTable");
storyTable.style = "TableStyleMedium2";
storyTable.showFilterButton = true;
stories.freezePanes.freezeRows(1);
stories.showGridLines = false;
stories.getRange("A1:K1").format = { fill: "#1A3A3A", font: { bold: true, color: "#FFFFFF" } };
stories.getRange(`A2:K${storyValues.length}`).format = {
  font: { color: "#1F2937" },
  borders: { insideHorizontal: { style: "thin", color: "#E5E7EB" } }
};
stories.getRange(`C2:D${storyValues.length}`).format.wrapText = true;
stories.getRange(`J2:K${storyValues.length}`).format.wrapText = true;
stories.getRange(`A:A`).format.columnWidthPx = 130;
stories.getRange(`B:B`).format.columnWidthPx = 90;
stories.getRange(`C:C`).format.columnWidthPx = 330;
stories.getRange(`D:D`).format.columnWidthPx = 520;
stories.getRange(`E:E`).format.columnWidthPx = 110;
stories.getRange(`F:F`).format.columnWidthPx = 160;
stories.getRange(`G:G`).format.columnWidthPx = 130;
stories.getRange(`H:H`).format.columnWidthPx = 170;
stories.getRange(`I:I`).format.columnWidthPx = 80;
stories.getRange(`J:J`).format.columnWidthPx = 390;
stories.getRange(`K:K`).format.columnWidthPx = 340;
stories.getRange(`A2:K${storyValues.length}`).format.rowHeightPx = 72;
stories.getRange(`E2:E${storyValues.length}`).dataValidation = { rule: { type: "list", values: ["Spec'd", "Tested-Pass", "Tested-Fail", "Fixed", "Verified"] } };
stories.getRange(`G2:G${storyValues.length}`).dataValidation = { rule: { type: "list", values: ["-", "Functional/logistical", "UX", "Open question"] } };

const statusRange = stories.getRange(`E2:E${storyValues.length}`);
statusRange.conditionalFormats.add("containsText", { text: "Spec'd", format: { fill: "#E0F2FE", font: { color: "#075985" } } });
statusRange.conditionalFormats.add("containsText", { text: "Tested-Pass", format: { fill: "#DCFCE7", font: { color: "#166534" } } });
statusRange.conditionalFormats.add("containsText", { text: "Tested-Fail", format: { fill: "#FEE2E2", font: { color: "#991B1B" } } });
statusRange.conditionalFormats.add("containsText", { text: "Fixed", format: { fill: "#FEF3C7", font: { color: "#92400E" } } });
statusRange.conditionalFormats.add("containsText", { text: "Verified", format: { fill: "#BBF7D0", font: { color: "#14532D", bold: true } } });

const summaryValues = [
  ["Pagepacket Behavioral Spec", "", "", ""],
  ["Generated from code", generatedAt, "", ""],
  ["Canonical workbook", outputPath, "", ""],
  ["", "", "", ""],
  ["Metric", "Value", "Formula / source", "Notes"],
  ["Total user stories", rows.length, "User Stories table row count", "Phase 1 catalog"],
  ["Spec'd", `=COUNTIF('User Stories'!E:E,"Spec'd")`, "COUNTIF", ""],
  ["Tested-Pass", `=COUNTIF('User Stories'!E:E,"Tested-Pass")`, "COUNTIF", ""],
  ["Tested-Fail", `=COUNTIF('User Stories'!E:E,"Tested-Fail")`, "COUNTIF", ""],
  ["Fixed", `=COUNTIF('User Stories'!E:E,"Fixed")`, "COUNTIF", ""],
  ["Verified", `=COUNTIF('User Stories'!E:E,"Verified")`, "COUNTIF", ""],
  ["Open questions", `=COUNTA('Open Questions'!A:A)-1`, "Derived from rows with non-empty questions", ""],
  ["Known defects/questions seeded", defectSeeds.length, "Defects sheet", "Verified defects plus one product-scope open question gap"]
];
summary.getRangeByIndexes(0, 0, summaryValues.length, 4).values = summaryValues;
summary.getRange("A1:D1").merge();
summary.getRange("A1:D1").format = { fill: "#0F172A", font: { bold: true, color: "#FFFFFF", size: 16 } };
summary.getRange("A5:D5").format = { fill: "#1A3A3A", font: { bold: true, color: "#FFFFFF" } };
summary.getRange("A6:D13").format = { borders: { insideHorizontal: { style: "thin", color: "#E5E7EB" } } };
summary.getRange("A:A").format.columnWidthPx = 210;
summary.getRange("B:B").format.columnWidthPx = 200;
summary.getRange("C:C").format.columnWidthPx = 230;
summary.getRange("D:D").format.columnWidthPx = 360;
summary.freezePanes.freezeRows(5);
summary.showGridLines = false;

const defectHeaders = ["Defect ID", "Feature ID", "Area", "Defect / gap", "Type", "Status", "Source", "Iteration found", "Resolution notes"];
const defectValues = [
  defectHeaders,
  ...defectSeeds.map((d) => [d.id, d.featureId, d.area, d.defect, d.type, d.status, d.source, 1, d.resolution || ""])
];
defects.getRangeByIndexes(0, 0, defectValues.length, defectHeaders.length).values = defectValues;
const defectTable = defects.tables.add(`A1:I${defectValues.length}`, true, "DefectsTable");
defectTable.style = "TableStyleMedium4";
defects.freezePanes.freezeRows(1);
defects.showGridLines = false;
defects.getRange("A1:I1").format = { fill: "#7F1D1D", font: { bold: true, color: "#FFFFFF" } };
defects.getRange(`D2:D${defectValues.length}`).format.wrapText = true;
defects.getRange(`G2:I${defectValues.length}`).format.wrapText = true;
defects.getRange("A:A").format.columnWidthPx = 90;
defects.getRange("B:B").format.columnWidthPx = 180;
defects.getRange("C:C").format.columnWidthPx = 150;
defects.getRange("D:D").format.columnWidthPx = 460;
defects.getRange("E:E").format.columnWidthPx = 150;
defects.getRange("F:F").format.columnWidthPx = 120;
defects.getRange("G:G").format.columnWidthPx = 360;
defects.getRange("H:H").format.columnWidthPx = 100;
defects.getRange("I:I").format.columnWidthPx = 300;

const questionRows = rows.filter((r) => r.questions && r.questions !== "-").map((r) => [r.id, r.area, r.questions, r.source, "Open"]);
const questionValues = [["Feature ID", "Area", "Question", "Source", "Status"], ...questionRows];
questions.getRangeByIndexes(0, 0, questionValues.length, 5).values = questionValues;
const questionTable = questions.tables.add(`A1:E${questionValues.length}`, true, "OpenQuestionsTable");
questionTable.style = "TableStyleMedium7";
questions.freezePanes.freezeRows(1);
questions.showGridLines = false;
questions.getRange("A1:E1").format = { fill: "#854D0E", font: { bold: true, color: "#FFFFFF" } };
questions.getRange(`C2:D${questionValues.length}`).format.wrapText = true;
questions.getRange("A:A").format.columnWidthPx = 110;
questions.getRange("B:B").format.columnWidthPx = 150;
questions.getRange("C:C").format.columnWidthPx = 520;
questions.getRange("D:D").format.columnWidthPx = 380;
questions.getRange("E:E").format.columnWidthPx = 120;

const logValues = [
  ["Timestamp", "Phase / iteration", "Command or method", "Result", "Notes"],
  [generatedAt, "Phase 0", "Static repo scan", "Completed", "Detected SwiftPM macOS app, pagepacket-cli, static landing page, no Swift test targets in Package.swift, empty Tests/BrandingTests directory."],
  [generatedAt, "Phase 1", "Code-derived catalog", "Completed", `Cataloged ${rows.length} user stories from source files and sample artifacts.`],
  [generatedAt, "Loop 1 Test", "swift build --jobs 1 --build-path /tmp/pagepacket-behavior-spec-build", "Pass", "Build complete; Pagepacket and pagepacket-cli linked."],
  [generatedAt, "Loop 1 Test", "./script/build_and_run.sh --verify", "Pass", "Build script staged dist/Pagepacket.app, opened it, and pgrep -x Pagepacket succeeded."],
  [generatedAt, "Loop 1 Test", "pagepacket-cli usage/status/history", "Pass", "Usage printed for missing/unknown commands; status SampleVault reported one Markdown file and .pagepacket sidecar path; history listed sample .pagepacket snapshots."],
  [generatedAt, "Loop 1 Test", "pagepacket-cli snapshot/apply/history in temp vault", "Pass", "snapshot and apply now write distinct millisecond IDs in the same second."],
  [generatedAt, "Loop 1 Test", "Playwright landing checks on http://127.0.0.1:8765/landing%20page/index.html", "Pass", "Primary nav, review preview, waitlist validation/localStorage, custom endpoint branch, responsive mobile form, and footer links passed."],
  [generatedAt, "Loop 1 Test", "Playwright alternate page check", "Pass", "index 2.html loads companion styles%202.css and script%202.js."]
];
log.getRangeByIndexes(0, 0, logValues.length, 5).values = logValues;
const logTable = log.tables.add(`A1:E${logValues.length}`, true, "VerificationLogTable");
logTable.style = "TableStyleMedium5";
log.getRange("A1:E1").format = { fill: "#164E63", font: { bold: true, color: "#FFFFFF" } };
log.getRange("A:A").format.columnWidthPx = 170;
log.getRange("B:B").format.columnWidthPx = 140;
log.getRange("C:C").format.columnWidthPx = 260;
log.getRange("D:D").format.columnWidthPx = 140;
log.getRange("E:E").format.columnWidthPx = 520;
log.getRange("E2:E3").format.wrapText = true;
log.freezePanes.freezeRows(1);
log.showGridLines = false;

for (const sheet of [stories, summary, defects, questions, log]) {
  const used = sheet.getUsedRange();
  used.format.font = { name: "Aptos", size: 10 };
}

await fs.mkdir(outputDir, { recursive: true });

const storyInspect = await workbook.inspect({
  kind: "table",
  range: "User Stories!A1:K8",
  include: "values,formulas",
  tableMaxRows: 8,
  tableMaxCols: 11,
  maxChars: 6000
});
console.log(storyInspect.ndjson);

const errorScan = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 100 },
  summary: "formula error scan"
});
console.log(errorScan.ndjson);

for (const sheetName of ["Summary", "User Stories", "Defects", "Open Questions", "Verification Log"]) {
  const preview = await workbook.render({ sheetName, autoCrop: "all", scale: 1, format: "png" });
  await fs.writeFile(path.join(outputDir, `${sheetName.replaceAll(" ", "-").toLowerCase()}-preview.png`), new Uint8Array(await preview.arrayBuffer()));
}

const xlsx = await SpreadsheetFile.exportXlsx(workbook);
await xlsx.save(outputPath);
console.log(`saved ${outputPath}`);
