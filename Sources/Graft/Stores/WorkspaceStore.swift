import AppKit
import Foundation
import SwiftUI
import UniformTypeIdentifiers

@MainActor
final class WorkspaceStore: ObservableObject {
    @Published var workspaceURL: URL?
    @Published var files: [MarkdownFile] = []
    @Published var selectedFile: MarkdownFile?
    @Published var editorText = ""
    @Published var lastLoadedText = ""
    @Published var editorMode: EditorMode = .split
    @Published var isInspectorVisible = true
    @Published var externalChangeBanner: String?
    @Published var snapshots: [VersionSnapshot] = []
    @Published var invites: [Invite] = [
        Invite(email: "maya@example.com", role: .editor),
        Invite(email: "reviewer@example.com", role: .commenter)
    ]
    @Published var agents: [AgentActivity] = [
        AgentActivity(name: "Codex", status: "Watching", detail: "Ready to edit plain files", accentName: "pink"),
        AgentActivity(name: "Claude Code", status: "Idle", detail: "Use CLI snapshot before broad edits", accentName: "teal"),
        AgentActivity(name: "Cursor", status: "Synced", detail: "External changes appear here", accentName: "lavender")
    ]
    @Published var autosaveEnabled = false
    @Published var externalChangeDetectionEnabled = true
    @Published var editorFontSize: Double = 15

    private let watcher = FileWatcher()
    private let renderer = MarkdownRenderer()

    var isDirty: Bool {
        editorText != lastLoadedText
    }

    var renderedBlocks: [MarkdownBlock] {
        renderer.blocks(from: editorText)
    }

    func bootstrap() {
        guard workspaceURL == nil else { return }
        let sample = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop/markdown/SampleVault", isDirectory: true)
        if FileManager.default.fileExists(atPath: sample.path) {
            openWorkspace(sample)
        }
    }

    func openWorkspacePanel() {
        let panel = NSOpenPanel()
        panel.title = "Open Markdown Workspace"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            openWorkspace(url)
        }
    }

    func openWorkspace(_ url: URL) {
        workspaceURL = url
        VersionHistoryStore(workspaceURL: url).prepare()
        reloadFileList()
        selectedFile = files.first
        if let selectedFile {
            load(file: selectedFile)
        }
        watcher.start(watching: files) { [weak self] changedURL in
            Task { @MainActor in
                self?.handleExternalChange(at: changedURL)
            }
        }
    }

    func reloadFileList() {
        guard let workspaceURL else { return }
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .contentModificationDateKey]
        guard let enumerator = FileManager.default.enumerator(
            at: workspaceURL,
            includingPropertiesForKeys: resourceKeys,
            options: [.skipsHiddenFiles]
        ) else {
            files = []
            return
        }

        files = enumerator
            .compactMap { $0 as? URL }
            .filter { $0.pathExtension.lowercased() == "md" }
            .filter { !$0.path.contains("/.pagepacket/") && !$0.path.contains("/.graft/") }
            .map { MarkdownFile(url: $0, workspaceURL: workspaceURL) }
            .sorted { $0.relativePath.localizedStandardCompare($1.relativePath) == .orderedAscending }
        watcher.update(files: files)
    }

    func load(file: MarkdownFile) {
        if isDirty {
            snapshotCurrentDocument(reason: "Before switching documents", source: "Pagepacket")
        }
        selectedFile = file
        let content = (try? String(contentsOf: file.url, encoding: .utf8)) ?? ""
        editorText = content
        lastLoadedText = content
        externalChangeBanner = nil
        refreshSnapshots()
    }

    func saveCurrentDocument() {
        guard let selectedFile else { return }
        snapshotCurrentDocument(reason: "Before save", source: "Pagepacket")
        do {
            try editorText.write(to: selectedFile.url, atomically: true, encoding: .utf8)
            lastLoadedText = editorText
            watcher.markClean(selectedFile.url)
            reloadFileList()
            refreshSnapshots()
        } catch {
            externalChangeBanner = "Could not save \(selectedFile.relativePath): \(error.localizedDescription)"
        }
    }

    func reloadSelectedFromDisk() {
        guard let selectedFile else { return }
        let content = (try? String(contentsOf: selectedFile.url, encoding: .utf8)) ?? ""
        snapshotCurrentDocument(reason: "Before accepting external change", source: "Pagepacket")
        editorText = content
        lastLoadedText = content
        externalChangeBanner = nil
        refreshSnapshots()
    }

    func keepLocalVersion() {
        saveCurrentDocument()
        externalChangeBanner = nil
    }

    func snapshotCurrentDocument(reason: String, source: String) {
        guard let workspaceURL, let selectedFile else { return }
        if let snapshot = VersionHistoryStore(workspaceURL: workspaceURL)
            .snapshot(file: selectedFile, content: editorText, reason: reason, source: source) {
            snapshots.insert(snapshot, at: 0)
        }
    }

    func restore(_ snapshot: VersionSnapshot) {
        guard let workspaceURL, let selectedFile else { return }
        let store = VersionHistoryStore(workspaceURL: workspaceURL)
        guard let content = store.restoreContent(from: snapshot) else { return }
        self.snapshotCurrentDocument(reason: "Before restore", source: "Pagepacket")
        editorText = content
        do {
            try content.write(to: selectedFile.url, atomically: true, encoding: .utf8)
            lastLoadedText = content
            watcher.markClean(selectedFile.url)
            refreshSnapshots()
        } catch {
            externalChangeBanner = "Could not restore snapshot: \(error.localizedDescription)"
        }
    }

    func refreshSnapshots() {
        guard let workspaceURL, let selectedFile else {
            snapshots = []
            return
        }
        snapshots = VersionHistoryStore(workspaceURL: workspaceURL).snapshots(for: selectedFile)
    }

    func insertImageFromPanel() {
        guard let workspaceURL, let selectedFile else { return }
        let panel = NSOpenPanel()
        panel.title = "Insert Image"
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.png, .jpeg, .gif, .tiff, .heic, .webP]
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            let importer = ImageImportService(workspaceURL: workspaceURL)
            if let markdown = importer.importImage(from: url, for: selectedFile) {
                editorText += editorText.hasSuffix("\n") ? "\n\(markdown)\n" : "\n\n\(markdown)\n"
                snapshotCurrentDocument(reason: "Inserted image", source: "Pagepacket")
            }
        }
    }

    func addInvite(email: String, role: InviteRole) {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        invites.append(Invite(email: email, role: role))
        writeInviteManifest()
    }

    func removeInvite(_ invite: Invite) {
        invites.removeAll { $0.id == invite.id }
        writeInviteManifest()
    }

    func composeEmail(for invite: Invite) {
        guard let workspaceURL else { return }
        writeInviteManifest()
        let subject = "Invitation to collaborate in Pagepacket"
        let body = """
        You have been invited as \(invite.role.title.lowercased()) to the Pagepacket workspace "\(workspaceURL.lastPathComponent)".

        Workspace path:
        \(workspaceURL.path)

        Pagepacket keeps Markdown files local-first. Open this folder in Pagepacket or edit the .md files directly with your coding agent, then use pagepacket-cli snapshot/apply to register changes.
        """

        var components = URLComponents()
        components.scheme = "mailto"
        components.path = invite.email
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body)
        ]
        if let url = components.url {
            NSWorkspace.shared.open(url)
        }
    }

    private func handleExternalChange(at url: URL) {
        guard externalChangeDetectionEnabled else { return }
        reloadFileList()
        guard let selectedFile, selectedFile.url == url else {
            agents[0].status = "Changed"
            agents[0].detail = "External edit detected in another Markdown file"
            return
        }

        let diskText = (try? String(contentsOf: url, encoding: .utf8)) ?? ""
        guard diskText != lastLoadedText else { return }

        if isDirty {
            snapshotCurrentDocument(reason: "External change conflict base", source: "Pagepacket")
            externalChangeBanner = "External edit detected in \(selectedFile.relativePath). Review before overwriting."
            agents[0].status = "Conflict"
            agents[0].detail = "An agent or tool changed this file while local edits are unsaved"
        } else {
            editorText = diskText
            lastLoadedText = diskText
            externalChangeBanner = "Reloaded external edit from disk."
            agents[0].status = "Reloaded"
            agents[0].detail = "External file change merged into the editor"
            refreshSnapshots()
        }
    }

    private func writeInviteManifest() {
        guard let workspaceURL else { return }
        let sharesURL = workspaceURL
            .appendingPathComponent(".pagepacket", isDirectory: true)
            .appendingPathComponent("shares", isDirectory: true)
        try? FileManager.default.createDirectory(at: sharesURL, withIntermediateDirectories: true)
        let manifestURL = sharesURL.appendingPathComponent("invites.json")
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(invites) {
            try? data.write(to: manifestURL, options: .atomic)
        }
    }
}
