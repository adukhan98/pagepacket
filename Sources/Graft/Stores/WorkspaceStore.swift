import AppKit
import Foundation
import GraftCore
import SwiftUI
import UniformTypeIdentifiers

@MainActor
final class WorkspaceStore: ObservableObject {
    @Published var workspaceURL: URL?
    @Published var files: [MarkdownFile] = []
    @Published var selectedFile: MarkdownFile?
    @Published var editorText = ""
    @Published var lastLoadedText = ""
    @Published var editorMode: EditorMode = .edit
    @Published var isInspectorVisible = false
    @Published var externalChangeBanner: String?
    @Published var pendingChangeSets: [ChangeSet] = []
    @Published var selectedChangeSetID: ChangeSet.ID?
    @Published var snapshots: [VersionSnapshot] = []
    @Published var invites: [Invite] = []
    @Published var agents: [AgentActivity] = []
    @Published var autosaveEnabled = false
    @Published var externalChangeDetectionEnabled = true
    @Published var editorFontSize: Double = 15

    private let watcher = FileWatcher()
    private let renderer = MarkdownRenderer()
    private var fileBaselines: [URL: String] = [:]

    var isDirty: Bool {
        editorText != lastLoadedText
    }

    var renderedBlocks: [MarkdownBlock] {
        renderer.blocks(from: editorText)
    }

    func bootstrap() {
        guard workspaceURL == nil else { return }
        #if DEBUG
        guard ProcessInfo.processInfo.environment["PAGEPACKET_OPEN_SAMPLE_ON_LAUNCH"] == "1" else {
            return
        }
        let sample = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop/markdown/SampleVault", isDirectory: true)
        if FileManager.default.fileExists(atPath: sample.path) {
            openWorkspace(sample)
        }
        #endif
    }

    func toggleInspector() {
        let willShowInspector = !isInspectorVisible
        if willShowInspector, editorMode == .split {
            editorMode = .preview
        }
        isInspectorVisible = willShowInspector
    }

    func setEditorMode(_ mode: EditorMode) {
        if isInspectorVisible, mode == .split {
            editorMode = .preview
        } else {
            editorMode = mode
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
        let normalizedURL = PathUtilities.normalized(url)
        workspaceURL = normalizedURL
        fileBaselines = [:]
        VersionHistoryStore(workspaceURL: normalizedURL).prepare()
        loadInviteManifest()
        loadReviewQueue()
        reloadFileList()
        selectedFile = files.first
        if let selectedFile {
            load(file: selectedFile)
        } else {
            clearDocumentState()
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
            .map(PathUtilities.normalized)
            .filter { $0.pathExtension.lowercased() == "md" }
            .filter { !$0.path.contains("/.pagepacket/") && !$0.path.contains("/.graft/") }
            .filter { $0.lastPathComponent != "AGENTS.md" }
            .map { MarkdownFile(url: $0, workspaceURL: workspaceURL) }
            .sorted { $0.relativePath.localizedStandardCompare($1.relativePath) == .orderedAscending }
        for file in files where fileBaselines[file.url] == nil {
            fileBaselines[file.url] = (try? String(contentsOf: file.url, encoding: .utf8)) ?? ""
        }
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
        fileBaselines[file.url] = content
        externalChangeBanner = nil
        selectedChangeSetID = pendingChangeSets.first { $0.filePath == file.relativePath }?.id
        refreshSnapshots()
    }

    func saveCurrentDocument() {
        guard let selectedFile else { return }
        snapshotCurrentDocument(reason: "Before save", source: "Pagepacket", content: lastLoadedText)
        do {
            try editorText.write(to: selectedFile.url, atomically: true, encoding: .utf8)
            lastLoadedText = editorText
            fileBaselines[selectedFile.url] = editorText
            watcher.markClean(selectedFile.url)
            reloadFileList()
            refreshSnapshots()
        } catch {
            externalChangeBanner = "Could not save \(selectedFile.relativePath): \(error.localizedDescription)"
        }
    }

    func autosaveCurrentDocumentIfNeeded() {
        guard autosaveEnabled, let selectedFile, editorText != lastLoadedText else { return }
        do {
            try editorText.write(to: selectedFile.url, atomically: true, encoding: .utf8)
            lastLoadedText = editorText
            fileBaselines[selectedFile.url] = editorText
            watcher.markClean(selectedFile.url)
            reloadFileList()
        } catch {
            externalChangeBanner = "Could not autosave \(selectedFile.relativePath): \(error.localizedDescription)"
        }
    }

    func reloadSelectedFromDisk() {
        guard let selectedFile else { return }
        let content = (try? String(contentsOf: selectedFile.url, encoding: .utf8)) ?? ""
        snapshotCurrentDocument(reason: "Before accepting external change", source: "Pagepacket")
        editorText = content
        lastLoadedText = content
        fileBaselines[selectedFile.url] = content
        externalChangeBanner = nil
        refreshSnapshots()
    }

    func keepLocalVersion() {
        saveCurrentDocument()
        externalChangeBanner = nil
    }

    func accept(_ changeSet: ChangeSet) {
        guard let selectedFile, selectedFile.relativePath == changeSet.filePath else { return }
        guard editorText == changeSet.baseText else {
            markReviewConflict(changeSet, currentText: editorText)
            externalChangeBanner = "This proposal now conflicts with your current draft. Review it as a conflict before accepting."
            return
        }

        var acceptedText = editorText
        do {
            for range in changeSet.ranges {
                acceptedText = try MarkdownPatchEngine().apply(range, to: acceptedText)
            }
        } catch MarkdownPatchError.staleHunk {
            markReviewConflict(changeSet, currentText: editorText)
            externalChangeBanner = "This proposal no longer matches your draft. Review it as a conflict before accepting."
            return
        } catch {
            externalChangeBanner = "Could not accept edit: \(error.localizedDescription)"
            return
        }

        snapshotCurrentDocument(reason: "Before accepting \(changeSet.authorName) edit", source: "Pagepacket")
        editorText = acceptedText
        do {
            try acceptedText.write(to: selectedFile.url, atomically: true, encoding: .utf8)
            lastLoadedText = acceptedText
            fileBaselines[selectedFile.url] = acceptedText
            watcher.markClean(selectedFile.url)
            updateReview(changeSet, status: .accepted)
            externalChangeBanner = "Accepted \(changeSet.authorName) edit."
            refreshSnapshots()
        } catch {
            externalChangeBanner = "Could not accept edit: \(error.localizedDescription)"
        }
    }

    func accept(_ range: ChangeRange, from changeSet: ChangeSet) {
        guard let selectedFile, selectedFile.relativePath == changeSet.filePath else { return }
        guard editorText == changeSet.baseText else {
            markReviewConflict(changeSet, currentText: editorText)
            externalChangeBanner = "That hunk no longer matches your draft. Review it as a conflict."
            return
        }
        do {
            let patched = try MarkdownPatchEngine().apply(range, to: editorText)
            snapshotCurrentDocument(reason: "Before accepting hunk from \(changeSet.authorName)", source: "Pagepacket")
            editorText = patched
            try patched.write(to: selectedFile.url, atomically: true, encoding: .utf8)
            lastLoadedText = patched
            fileBaselines[selectedFile.url] = patched
            watcher.markClean(selectedFile.url)
            remove(range, from: changeSet, finalStatus: .accepted, nextBaseText: patched)
            externalChangeBanner = "Accepted one hunk from \(changeSet.authorName)."
            refreshSnapshots()
        } catch MarkdownPatchError.staleHunk {
            markReviewConflict(changeSet, currentText: editorText)
            externalChangeBanner = "That hunk no longer matches your draft. Review it as a conflict."
        } catch {
            externalChangeBanner = "Could not accept hunk: \(error.localizedDescription)"
        }
    }

    func reject(_ changeSet: ChangeSet) {
        updateReview(changeSet, status: .rejected)
        externalChangeBanner = "Rejected \(changeSet.authorName) edit."
        if let selectedFile, selectedFile.relativePath == changeSet.filePath {
            restoreVisibleDraftToDisk(for: selectedFile)
        }
    }

    func reject(_ range: ChangeRange, from changeSet: ChangeSet) {
        remove(range, from: changeSet, finalStatus: .rejected, nextBaseText: editorText)
        externalChangeBanner = "Rejected one hunk from \(changeSet.authorName)."
        if let selectedFile, selectedFile.relativePath == changeSet.filePath {
            restoreVisibleDraftToDisk(for: selectedFile)
        }
    }

    func focus(_ changeSet: ChangeSet) {
        if selectedFile?.relativePath != changeSet.filePath,
           let file = files.first(where: { $0.relativePath == changeSet.filePath }) {
            load(file: file)
        }
        selectedChangeSetID = changeSet.id
    }

    func createReviewPacket() {
        guard let selectedFile else { return }
        snapshotCurrentDocument(reason: "Review packet checkpoint", source: "Pagepacket")
        externalChangeBanner = "Review packet checkpoint created for \(selectedFile.relativePath)."
    }

    func snapshotCurrentDocument(reason: String, source: String, content: String? = nil) {
        guard let workspaceURL, let selectedFile else { return }
        if let snapshot = VersionHistoryStore(workspaceURL: workspaceURL)
            .snapshot(file: selectedFile, content: content ?? editorText, reason: reason, source: source) {
            snapshots.insert(snapshot, at: 0)
        }
    }

    func restore(_ snapshot: VersionSnapshot) {
        guard let workspaceURL, let selectedFile else { return }
        let store = VersionHistoryStore(workspaceURL: workspaceURL)
        guard let content = store.restoreContent(from: snapshot) else { return }
        snapshotCurrentDocument(reason: "Before restore", source: "Pagepacket")
        editorText = content
        do {
            try content.write(to: selectedFile.url, atomically: true, encoding: .utf8)
            lastLoadedText = content
            fileBaselines[selectedFile.url] = content
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

    @discardableResult
    func addInvite(email: String, role: InviteRole) -> InviteAddResult {
        let normalizedEmail = normalizedInviteEmail(email)
        guard isValidInviteEmail(normalizedEmail) else { return .invalidEmail }
        guard !invites.contains(where: { normalizedInviteEmail($0.email) == normalizedEmail }) else {
            return .duplicate
        }
        invites.append(Invite(email: normalizedEmail, role: role))
        writeInviteManifest()
        return .added
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

        Pagepacket keeps Markdown files local-first. Open this folder in Pagepacket or edit the .md files directly with your coding agent, then use pagepacket-cli snapshot/submit-change to register changes.
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
        guard let changedFile = files.first(where: { $0.url == url }) else {
            recordAgentActivity(
                status: "Changed",
                detail: "External edit detected in another Markdown file"
            )
            return
        }

        let diskText = (try? String(contentsOf: url, encoding: .utf8)) ?? ""
        let isSelectedFile = selectedFile?.url == url
        let baseText = isSelectedFile ? lastLoadedText : (fileBaselines[url] ?? "")
        guard diskText != baseText else { return }

        let isConflict = isSelectedFile && isDirty
        let reviewBaseText = isConflict ? editorText : baseText
        if createReview(from: diskText, for: changedFile, baseText: reviewBaseText, isConflict: isConflict) {
            let textToRestore = isSelectedFile ? reviewBaseText : baseText
            restoreTextToDisk(textToRestore, for: changedFile)
            refreshSnapshots()
        }
    }

    @discardableResult
    private func createReview(from diskText: String, for file: MarkdownFile, baseText: String, isConflict: Bool) -> Bool {
        guard let workspaceURL else { return false }
        if isConflict, selectedFile?.url == file.url {
            snapshotCurrentDocument(reason: "External change conflict base", source: "Pagepacket")
        }

        let ranges = MarkdownDiffEngine().changedRanges(before: baseText, after: diskText)
        guard !ranges.isEmpty else { return false }

        let metadataStore = ChangeMetadataStore(workspaceURL: workspaceURL)
        let metadata = metadataStore.metadata(for: file.relativePath)
            ?? metadataStore.fallbackMetadata(for: file.relativePath)
        let status: ChangeReviewStatus = isConflict ? .conflict : .pending
        let changeSet = ChangeSet(
            filePath: file.relativePath,
            authorName: metadata.agent,
            authorKind: metadata.agent == "external" ? .external : .agent,
            status: status,
            summary: metadata.summary,
            baseText: baseText,
            proposedText: diskText,
            ranges: ranges.map { range in
                ChangeRange(
                    id: range.id,
                    oldStartLine: range.oldStartLine,
                    oldEndLine: range.oldEndLine,
                    newStartLine: range.newStartLine,
                    newEndLine: range.newEndLine,
                    kind: range.kind,
                    before: range.before,
                    after: range.after,
                    isConflict: isConflict || range.isConflict
                )
            }
        )

        do {
            let store = ChangeSetStore(workspaceURL: workspaceURL)
            var supersededReviews: [ChangeSet] = []
            for reviewStatus in ChangeReviewStatus.allCases {
                let reviews = try store.load(status: reviewStatus)
                supersededReviews.append(contentsOf: reviews.filter { review in
                    review.filePath == file.relativePath && (review.status == .pending || review.status == .conflict)
                })
            }
            for supersededReview in supersededReviews {
                try store.delete(supersededReview)
            }
            try store.write(changeSet)
            loadReviewQueue()
            selectedChangeSetID = changeSet.id
        } catch {
            externalChangeBanner = "Could not create review packet: \(error.localizedDescription)"
            return false
        }

        externalChangeBanner = isConflict
            ? "External edit detected in \(file.relativePath). Review the packet before accepting."
            : "External edit is ready for review."
        recordAgentActivity(
            status: status == .conflict ? "Conflict" : "Pending review",
            detail: "\(metadata.agent) changed \(file.relativePath)"
        )
        return true
    }

    private func restoreTextToDisk(_ text: String, for file: MarkdownFile) {
        do {
            try text.write(to: file.url, atomically: true, encoding: .utf8)
            fileBaselines[file.url] = text
            if selectedFile?.url == file.url {
                editorText = text
                lastLoadedText = text
            }
            watcher.markClean(file.url)
        } catch {
            externalChangeBanner = "Could not preserve local draft: \(error.localizedDescription)"
        }
    }

    private func restoreVisibleDraftToDisk(for selectedFile: MarkdownFile) {
        restoreTextToDisk(editorText, for: selectedFile)
    }

    private func markReviewConflict(_ changeSet: ChangeSet, currentText: String) {
        guard let workspaceURL else { return }
        let conflict = ChangeSet(
            id: changeSet.id,
            filePath: changeSet.filePath,
            authorName: changeSet.authorName,
            authorKind: changeSet.authorKind,
            status: .conflict,
            summary: changeSet.summary,
            createdAt: changeSet.createdAt,
            baseText: currentText,
            proposedText: changeSet.proposedText,
            ranges: MarkdownDiffEngine().changedRanges(before: currentText, after: changeSet.proposedText)
        )
        let store = ChangeSetStore(workspaceURL: workspaceURL)
        try? store.delete(changeSet)
        try? store.write(conflict)
        if let index = pendingChangeSets.firstIndex(where: { $0.id == changeSet.id }) {
            pendingChangeSets[index] = conflict
        }
        selectedChangeSetID = conflict.id
    }

    private func remove(
        _ range: ChangeRange,
        from changeSet: ChangeSet,
        finalStatus: ChangeReviewStatus,
        nextBaseText: String
    ) {
        var remaining = changeSet.ranges
        remaining.removeAll { $0.id == range.id }
        if remaining.isEmpty {
            updateReview(changeSet, status: finalStatus)
            return
        }

        let updated = ChangeSet(
            id: changeSet.id,
            filePath: changeSet.filePath,
            authorName: changeSet.authorName,
            authorKind: changeSet.authorKind,
            status: changeSet.status,
            summary: changeSet.summary,
            createdAt: changeSet.createdAt,
            baseText: nextBaseText,
            proposedText: changeSet.proposedText,
            ranges: remaining
        )
        guard let workspaceURL else { return }
        let store = ChangeSetStore(workspaceURL: workspaceURL)
        try? store.delete(changeSet)
        try? store.write(updated)
        if let index = pendingChangeSets.firstIndex(where: { $0.id == changeSet.id }) {
            pendingChangeSets[index] = updated
        }
        selectedChangeSetID = updated.id
    }

    private func updateReview(_ changeSet: ChangeSet, status: ChangeReviewStatus) {
        guard let workspaceURL else { return }
        var updated = changeSet
        updated.status = status
        let store = ChangeSetStore(workspaceURL: workspaceURL)
        try? store.delete(changeSet)
        try? store.write(updated)
        pendingChangeSets.removeAll { $0.id == changeSet.id }
        selectedChangeSetID = pendingChangeSets.first?.id
    }

    private func loadReviewQueue() {
        guard let workspaceURL else {
            pendingChangeSets = []
            selectedChangeSetID = nil
            return
        }
        pendingChangeSets = ((try? ChangeSetStore(workspaceURL: workspaceURL).loadAll()) ?? [])
            .filter { $0.status == .pending || $0.status == .conflict }
        selectedChangeSetID = pendingChangeSets.first?.id
    }

    private func recordAgentActivity(status: String, detail: String) {
        let activity = AgentActivity(
            name: "File watcher",
            status: status,
            detail: detail,
            accentName: status == "Conflict" ? "pink" : "teal"
        )
        if agents.isEmpty {
            agents = [activity]
        } else {
            agents[0] = activity
        }
    }

    private func clearDocumentState() {
        selectedFile = nil
        editorText = ""
        lastLoadedText = ""
        externalChangeBanner = nil
        snapshots = []
        selectedChangeSetID = nil
    }

    private func inviteManifestURL() -> URL? {
        workspaceURL?
            .appendingPathComponent(".pagepacket", isDirectory: true)
            .appendingPathComponent("shares", isDirectory: true)
            .appendingPathComponent("invites.json")
    }

    private func loadInviteManifest() {
        guard let manifestURL = inviteManifestURL(),
              let data = try? Data(contentsOf: manifestURL),
              let decoded = try? JSONDecoder().decode([Invite].self, from: data) else {
            invites = []
            return
        }

        var seen = Set<String>()
        invites = decoded.compactMap { invite in
            let normalizedEmail = normalizedInviteEmail(invite.email)
            guard isValidInviteEmail(normalizedEmail), !seen.contains(normalizedEmail) else {
                return nil
            }
            seen.insert(normalizedEmail)
            var normalizedInvite = invite
            normalizedInvite.email = normalizedEmail
            return normalizedInvite
        }
    }

    private func writeInviteManifest() {
        guard let manifestURL = inviteManifestURL() else { return }
        let sharesURL = manifestURL.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: sharesURL, withIntermediateDirectories: true)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(invites) {
            try? data.write(to: manifestURL, options: .atomic)
        }
    }

    private func normalizedInviteEmail(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func isValidInviteEmail(_ email: String) -> Bool {
        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2,
              let local = parts.first,
              let domain = parts.last,
              !local.isEmpty,
              domain.contains("."),
              !email.contains(where: \.isWhitespace) else {
            return false
        }
        return true
    }
}
