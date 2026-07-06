import AppKit
import Foundation
import SwiftUI

enum RegressionFailure: Error, CustomStringConvertible {
    case failed(String)

    var description: String {
        switch self {
        case let .failed(message): message
        }
    }
}

func expect(_ condition: @autoclosure () -> Bool, _ message: String) throws {
    guard condition() else {
        throw RegressionFailure.failed(message)
    }
}

func expectEqual<T: Equatable>(_ actual: T, _ expected: T, _ message: String) throws {
    guard actual == expected else {
        throw RegressionFailure.failed("\(message): expected \(expected), got \(actual)")
    }
}

func temporaryVault() throws -> URL {
    let url = FileManager.default.temporaryDirectory
        .appendingPathComponent("pagepacket-regression", isDirectory: true)
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .standardizedFileURL
    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    return url
}

func testOrderedItemsPreserveSourceNumber() throws {
    let blocks = MarkdownRenderer().blocks(from: "3. Third\n10. Tenth")

    guard case let .orderedItem(firstNumber, firstText) = blocks[0].kind else {
        throw RegressionFailure.failed("Expected first block to be an ordered item")
    }
    guard case let .orderedItem(secondNumber, secondText) = blocks[1].kind else {
        throw RegressionFailure.failed("Expected second block to be an ordered item")
    }

    try expectEqual(firstNumber, 3, "First ordered item number")
    try expectEqual(firstText, "Third", "First ordered item text")
    try expectEqual(secondNumber, 10, "Second ordered item number")
    try expectEqual(secondText, "Tenth", "Second ordered item text")
}

func testBlockIDsAreStableAndUniqueForRepeatedContent() throws {
    let renderer = MarkdownRenderer()
    let markdown = "repeat\nrepeat\n---\n---"

    let firstPass = renderer.blocks(from: markdown).map(\.id)
    let secondPass = renderer.blocks(from: markdown).map(\.id)

    try expectEqual(firstPass, secondPass, "Block IDs should be stable across renders")
    try expectEqual(Set(firstPass).count, firstPass.count, "Block IDs should be unique within one render")
}

func testNestedDocumentReceivesRelativeImagePath() throws {
    let vault = try temporaryVault()
    let notes = vault.appendingPathComponent("notes", isDirectory: true)
    try FileManager.default.createDirectory(at: notes, withIntermediateDirectories: true)
    let documentURL = notes.appendingPathComponent("entry.md")
    try "# Entry".write(to: documentURL, atomically: true, encoding: .utf8)
    let imageURL = vault.appendingPathComponent("source.png")
    try Data([0, 1, 2, 3]).write(to: imageURL)

    let file = MarkdownFile(url: documentURL, workspaceURL: vault)
    guard let markdown = ImageImportService(workspaceURL: vault).importImage(from: imageURL, for: file) else {
        throw RegressionFailure.failed("Image import returned nil")
    }

    try expect(!markdown.contains(vault.path), "Image Markdown should not contain the absolute vault path")
    try expect(markdown.hasPrefix("![source](../assets/entry/source-"), "Image Markdown should be relative to the nested document")
    try expect(markdown.hasSuffix(".png)"), "Image Markdown should preserve the extension")
}

func testSimilarRelativePathsUseDifferentHistoryFolders() throws {
    let vault = try temporaryVault()
    let nestedFolder = vault.appendingPathComponent("a", isDirectory: true)
    try FileManager.default.createDirectory(at: nestedFolder, withIntermediateDirectories: true)

    let nestedURL = nestedFolder.appendingPathComponent("b.md")
    let flatURL = vault.appendingPathComponent("a__b.md")
    try "# Nested".write(to: nestedURL, atomically: true, encoding: .utf8)
    try "# Flat".write(to: flatURL, atomically: true, encoding: .utf8)

    let store = VersionHistoryStore(workspaceURL: vault)
    guard let nested = store.snapshot(
        file: MarkdownFile(url: nestedURL, workspaceURL: vault),
        content: "# Nested",
        reason: "nested",
        source: "test"
    ) else {
        throw RegressionFailure.failed("Nested snapshot failed")
    }
    guard let flat = store.snapshot(
        file: MarkdownFile(url: flatURL, workspaceURL: vault),
        content: "# Flat",
        reason: "flat",
        source: "test"
    ) else {
        throw RegressionFailure.failed("Flat snapshot failed")
    }

    try expect(
        nested.snapshotURL.deletingLastPathComponent().lastPathComponent != flat.snapshotURL.deletingLastPathComponent().lastPathComponent,
        "Similar relative paths should not share a history folder"
    )
}

@MainActor
func testWorkspaceDiscoversMarkdownFilesAndExcludesSidecars() throws {
    let vault = try temporaryVault()
    try "# Root".write(to: vault.appendingPathComponent("root.md"), atomically: true, encoding: .utf8)
    let docs = vault.appendingPathComponent("docs", isDirectory: true)
    try FileManager.default.createDirectory(at: docs, withIntermediateDirectories: true)
    try "# Nested".write(to: docs.appendingPathComponent("nested.md"), atomically: true, encoding: .utf8)
    let sidecar = vault.appendingPathComponent(".pagepacket", isDirectory: true)
    try FileManager.default.createDirectory(at: sidecar, withIntermediateDirectories: true)
    try "# Hidden".write(to: sidecar.appendingPathComponent("hidden.md"), atomically: true, encoding: .utf8)

    let store = WorkspaceStore()
    store.openWorkspace(vault)

    try expectEqual(store.files.map(\.relativePath), ["docs/nested.md", "root.md"], "Workspace Markdown file list")
    try expectEqual(store.selectedFile?.relativePath, "docs/nested.md", "Workspace should select the first sorted Markdown file")
}

@MainActor
func testWorkspaceSaveSnapshotAndRestore() throws {
    let vault = try temporaryVault()
    let fileURL = vault.appendingPathComponent("welcome.md")
    try "Original".write(to: fileURL, atomically: true, encoding: .utf8)

    let store = WorkspaceStore()
    store.openWorkspace(vault)
    try expectEqual(store.editorText, "Original", "Workspace should load selected file text")

    store.editorText = "Changed"
    store.saveCurrentDocument()
    try expectEqual(try String(contentsOf: fileURL, encoding: .utf8), "Changed", "Save should write editor text")
    try expect(!store.snapshots.isEmpty, "Save should create a before-save snapshot")

    guard let beforeSave = store.snapshots.first(where: { $0.reason == "Before save" }) else {
        throw RegressionFailure.failed("Missing before-save snapshot")
    }
    store.restore(beforeSave)
    try expectEqual(try String(contentsOf: fileURL, encoding: .utf8), "Original", "Restore should write snapshot text")
    try expectEqual(store.editorText, "Original", "Restore should update editor text")
}

@MainActor
func testOpenWorkspaceLoadsPersistedInvitesWithoutExampleSeedData() throws {
    let vault = try temporaryVault()
    try "# Welcome".write(to: vault.appendingPathComponent("welcome.md"), atomically: true, encoding: .utf8)
    let shares = vault
        .appendingPathComponent(".pagepacket", isDirectory: true)
        .appendingPathComponent("shares", isDirectory: true)
    try FileManager.default.createDirectory(at: shares, withIntermediateDirectories: true)
    let persisted = [Invite(email: "stored@example.com", role: .commenter)]
    let data = try JSONEncoder().encode(persisted)
    try data.write(to: shares.appendingPathComponent("invites.json"))

    let store = WorkspaceStore()
    store.openWorkspace(vault)

    try expectEqual(store.invites.map(\.email), ["stored@example.com"], "Workspace should load persisted invite emails")
    try expectEqual(store.invites.map(\.role), [.commenter], "Workspace should load persisted invite roles")
}

@MainActor
func testAddInviteRejectsInvalidAndDuplicateEmails() throws {
    let vault = try temporaryVault()
    try "# Welcome".write(to: vault.appendingPathComponent("welcome.md"), atomically: true, encoding: .utf8)
    let store = WorkspaceStore()
    store.openWorkspace(vault)

    try expectEqual(store.addInvite(email: "not an email", role: .editor), .invalidEmail, "Invalid email result")
    try expectEqual(store.invites, [], "Invalid invite should not be added")
    try expectEqual(store.addInvite(email: "User@Example.com", role: .editor), .added, "Valid invite result")
    try expectEqual(store.addInvite(email: " user@example.com ", role: .viewer), .duplicate, "Duplicate invite result")
    try expectEqual(store.invites.map(\.email), ["user@example.com"], "Invite email should be normalized")
}

@main
struct RegressionCheck {
    static func main() async {
        do {
            try testOrderedItemsPreserveSourceNumber()
            try testBlockIDsAreStableAndUniqueForRepeatedContent()
            try testNestedDocumentReceivesRelativeImagePath()
            try testSimilarRelativePathsUseDifferentHistoryFolders()
            try await MainActor.run {
                try testWorkspaceDiscoversMarkdownFilesAndExcludesSidecars()
                try testWorkspaceSaveSnapshotAndRestore()
                try testOpenWorkspaceLoadsPersistedInvitesWithoutExampleSeedData()
                try testAddInviteRejectsInvalidAndDuplicateEmails()
            }
            print("regression checks passed")
        } catch {
            print("regression check failed: \(error)")
            exit(1)
        }
    }
}
