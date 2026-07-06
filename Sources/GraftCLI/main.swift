import Darwin
import Foundation
import GraftCore

struct PagepacketCLI {
    static func main() {
        let args = Array(CommandLine.arguments.dropFirst())
        guard let command = args.first else {
            printUsage()
            return
        }

        switch command {
        case "status":
            status(args: Array(args.dropFirst()))
        case "submit-change":
            submitChange(args: Array(args.dropFirst()))
        case "snapshot":
            snapshot(args: Array(args.dropFirst()), source: "pagepacket-cli")
        case "apply":
            apply(args: Array(args.dropFirst()))
        case "history":
            history(args: Array(args.dropFirst()))
        default:
            printUsage()
        }
    }

    private static func status(args: [String]) {
        guard let vault = args.first.map({ normalized(URL(fileURLWithPath: $0)) }) else {
            fail("missing vault path")
        }
        let files = markdownFiles(in: vault)
        print("Pagepacket vault: \(vault.path)")
        print("Markdown files: \(files.count)")
        print("Sidecar: \(vault.appendingPathComponent(".pagepacket").path)")
        let changes = changeMetadataFiles(in: vault)
        print("Pending change metadata: \(changes.count)")
        files.prefix(12).forEach { print("- \(relativePath(from: vault, to: $0))") }
        changes.prefix(6).forEach { print("change: \($0.lastPathComponent)") }
    }

    private static func submitChange(args: [String]) {
        guard args.count >= 2 else {
            fail("usage: pagepacket-cli submit-change <vault> <file> --agent codex --summary \"Tightened welcome copy\"")
        }

        let vault = normalized(URL(fileURLWithPath: args[0]))
        let relativePath = args[1]
        let file = normalized(vault.appendingPathComponent(relativePath))
        guard isInside(file, vault: vault) else {
            fail("refusing to read file outside the vault: \(relativePath)")
        }
        let agent = option("--agent", in: args) ?? "agent"
        let summary = option("--summary", in: args) ?? "Agent edit submitted for review"

        guard FileManager.default.fileExists(atPath: file.path) else {
            fail("could not find \(file.path)")
        }

        do {
            let metadataURL = try writeChangeMetadata(
                vault: vault,
                filePath: relativePath,
                agent: agent,
                summary: summary
            )
            print("change metadata written: \(metadataURL.path)")
            print("metadata format: Pagepacket ChangeMetadata-compatible JSON")
            writeSnapshot(vault: vault, file: file, reason: "Submitted agent change: \(summary)", source: agent)
        } catch {
            fail("could not write change metadata: \(error.localizedDescription)")
        }
    }

    private static func snapshot(args: [String], source: String) {
        guard args.count >= 2 else {
            fail("usage: pagepacket-cli snapshot <vault> <file> --message \"Before edits\"")
        }
        let vault = normalized(URL(fileURLWithPath: args[0]))
        let file = normalized(vault.appendingPathComponent(args[1]))
        guard isInside(file, vault: vault) else {
            fail("refusing to read file outside the vault: \(args[1])")
        }
        let message = option("--message", in: args) ?? "CLI checkpoint"
        writeSnapshot(vault: vault, file: file, reason: message, source: source)
    }

    private static func apply(args: [String]) {
        guard args.count >= 2 else {
            fail("usage: pagepacket-cli apply <vault> <file> --author codex")
        }
        let vault = normalized(URL(fileURLWithPath: args[0]))
        let file = normalized(vault.appendingPathComponent(args[1]))
        guard isInside(file, vault: vault) else {
            fail("refusing to read file outside the vault: \(args[1])")
        }
        let author = option("--author", in: args) ?? "agent"
        writeSnapshot(vault: vault, file: file, reason: "External edit checkpoint by \(author)", source: author)
        print("note: apply is a legacy snapshot-only alias; use submit-change to register review metadata")
    }

    private static func history(args: [String]) {
        guard args.count >= 2 else {
            fail("usage: pagepacket-cli history <vault> <file>")
        }
        let vault = normalized(URL(fileURLWithPath: args[0]))
        let file = normalized(vault.appendingPathComponent(args[1]))
        guard isInside(file, vault: vault) else {
            fail("refusing to read file outside the vault: \(args[1])")
        }
        let folders = [
            vault.appendingPathComponent(".pagepacket/history/\(historyFolderName(for: args[1]))", isDirectory: true),
            vault.appendingPathComponent(".pagepacket/history/\(legacyHistoryFolderName(for: args[1]))", isDirectory: true),
            vault.appendingPathComponent(".graft/history/\(legacyHistoryFolderName(for: args[1]))", isDirectory: true)
        ]
        let snapshots = folders.flatMap { folder in
            (try? FileManager.default.contentsOfDirectory(
                at: folder,
                includingPropertiesForKeys: [.contentModificationDateKey]
            )) ?? []
        }
        if snapshots.isEmpty {
            print("No snapshots for \(args[1])")
        } else {
            for url in snapshots.sorted(by: { $0.lastPathComponent > $1.lastPathComponent }) {
                print(url.deletingPathExtension().lastPathComponent)
            }
        }

        let changes = changeMetadataFiles(in: vault, matching: args[1])
        guard !changes.isEmpty else {
            return
        }
        print("Submitted changes:")
        for url in changes.sorted(by: { $0.lastPathComponent > $1.lastPathComponent }) {
            print(url.deletingPathExtension().lastPathComponent)
        }
    }

    private static func writeChangeMetadata(vault: URL, filePath: String, agent: String, summary: String) throws -> URL {
        let folder = vault.appendingPathComponent(".pagepacket/changes", isDirectory: true)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        let now = Date()
        let timestamp = timestampForFilename(now)
        let coreMetadata = ChangeMetadata(filePath: filePath, agent: agent, summary: summary)
        let metadata = ChangeMetadataEnvelope(
            id: UUID(),
            metadataVersion: 1,
            filePath: coreMetadata.filePath,
            agent: coreMetadata.agent,
            authorName: coreMetadata.agent,
            authorKind: "agent",
            summary: coreMetadata.summary,
            status: "pending",
            source: "pagepacket-cli",
            createdAt: ISO8601DateFormatter().string(from: now)
        )
        let url = folder.appendingPathComponent("\(timestamp)-\(legacyHistoryFolderName(for: agent)).json")
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encoder.encode(metadata).write(to: url, options: [.atomic])
        return url
    }

    private static func writeSnapshot(vault: URL, file: URL, reason: String, source: String) {
        guard let content = try? String(contentsOf: file, encoding: .utf8) else {
            fail("could not read \(file.path)")
        }
        let relative = relativePath(from: vault, to: file)
        let folder = vault.appendingPathComponent(".pagepacket/history/\(historyFolderName(for: relative))", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        let timestamp = Date()
        let id = timestampForFilename(timestamp)
        let snapshotURL = folder.appendingPathComponent("\(id).md")
        let header = """
        ---
        pagepacket_document: \(relative)
        pagepacket_source: \(source)
        pagepacket_reason: \(reason)
        pagepacket_created_at: \(ISO8601DateFormatter().string(from: timestamp))
        ---

        """
        do {
            try (header + content).write(to: snapshotURL, atomically: true, encoding: .utf8)
            print("snapshot \(id) written for \(relative)")
        } catch {
            fail("could not write snapshot: \(error.localizedDescription)")
        }
    }

    private static func markdownFiles(in vault: URL) -> [URL] {
        guard let enumerator = FileManager.default.enumerator(at: vault, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) else {
            return []
        }
        return enumerator
            .compactMap { $0 as? URL }
            .map(normalized)
            .filter { $0.pathExtension.lowercased() == "md" }
            .filter { !$0.path.contains("/.pagepacket/") && !$0.path.contains("/.graft/") }
            .filter { $0.lastPathComponent != "AGENTS.md" }
            .sorted { $0.path < $1.path }
    }

    private static func changeMetadataFiles(in vault: URL, matching filePath: String? = nil) -> [URL] {
        let folder = vault.appendingPathComponent(".pagepacket/changes", isDirectory: true)
        guard let urls = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil) else {
            return []
        }
        let jsonFiles = urls.filter { $0.pathExtension.lowercased() == "json" }
        guard let filePath else {
            return jsonFiles.sorted { $0.path < $1.path }
        }
        return jsonFiles
            .filter { changeMetadata(at: $0)?.filePath == filePath }
            .sorted { $0.path < $1.path }
    }

    private static func changeMetadata(at url: URL) -> ChangeMetadataEnvelope? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? JSONDecoder().decode(ChangeMetadataEnvelope.self, from: data)
    }

    private static func option(_ name: String, in args: [String]) -> String? {
        guard let index = args.firstIndex(of: name), args.indices.contains(index + 1) else {
            return nil
        }
        return args[index + 1]
    }

    private static func normalized(_ url: URL) -> URL {
        url.standardizedFileURL.resolvingSymlinksInPath()
    }

    private static func isInside(_ file: URL, vault: URL) -> Bool {
        let vaultPath = normalized(vault).path
        let filePath = normalized(file).path
        return filePath == vaultPath || filePath.hasPrefix(vaultPath + "/")
    }

    private static func relativePath(from baseDirectory: URL, to target: URL) -> String {
        let baseComponents = normalized(baseDirectory).pathComponents
        let targetComponents = normalized(target).pathComponents
        var sharedCount = 0

        while sharedCount < baseComponents.count,
              sharedCount < targetComponents.count,
              baseComponents[sharedCount] == targetComponents[sharedCount] {
            sharedCount += 1
        }

        let parentSteps = Array(repeating: "..", count: baseComponents.count - sharedCount)
        let childSteps = Array(targetComponents.dropFirst(sharedCount))
        let relativeComponents = parentSteps + childSteps
        return relativeComponents.isEmpty ? "." : relativeComponents.joined(separator: "/")
    }

    private static func historyFolderName(for path: String) -> String {
        "\(legacyHistoryFolderName(for: path))__\(hexEncoded(path))"
    }

    private static func legacyHistoryFolderName(for path: String) -> String {
        path.replacingOccurrences(of: "/", with: "__")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ".", with: "_")
    }

    private static func hexEncoded(_ path: String) -> String {
        path.utf8.map { String(format: "%02x", $0) }.joined()
    }

    private static func timestampForFilename(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss-SSS"
        return formatter.string(from: date)
    }

    private static func printUsage() {
        print("""
        Pagepacket CLI

        Commands:
          pagepacket-cli status <vault>
          pagepacket-cli submit-change <vault> <file> --agent codex --summary "Tightened welcome copy"
          pagepacket-cli snapshot <vault> <file> --message "Before edits"
          pagepacket-cli apply <vault> <file> --author codex  # legacy snapshot-only alias
          pagepacket-cli history <vault> <file>
        """)
    }

    private static func fail(_ message: String) -> Never {
        fputs("\(message)\n", stderr)
        exit(1)
    }
}

struct ChangeMetadataEnvelope: Codable {
    let id: UUID?
    let metadataVersion: Int?
    let filePath: String
    let agent: String
    let authorName: String?
    let authorKind: String?
    let summary: String
    let status: String?
    let source: String?
    let createdAt: String?
}

PagepacketCLI.main()
