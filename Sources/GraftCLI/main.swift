import Foundation
import GraftCore

struct GraftCLI {
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
            snapshot(args: Array(args.dropFirst()), source: "graft-cli")
        case "apply":
            apply(args: Array(args.dropFirst()))
        case "history":
            history(args: Array(args.dropFirst()))
        default:
            printUsage()
        }
    }

    private static func status(args: [String]) {
        guard let vault = args.first.map({ URL(fileURLWithPath: $0).standardizedFileURL }) else {
            print("missing vault path")
            return
        }
        let files = markdownFiles(in: vault)
        print("Graft vault: \(vault.path)")
        print("Markdown files: \(files.count)")
        print("Sidecar: \(vault.appendingPathComponent(".graft").path)")
        let changes = changeMetadataFiles(in: vault)
        print("Pending change metadata: \(changes.count)")
        files.prefix(12).forEach { print("- \(relativePath(for: $0, in: vault))") }
        changes.prefix(6).forEach { print("change: \($0.lastPathComponent)") }
    }

    private static func submitChange(args: [String]) {
        guard args.count >= 2 else {
            print("usage: graft-cli submit-change <vault> <file> --agent codex --summary \"Tightened welcome copy\"")
            return
        }

        let vault = URL(fileURLWithPath: args[0]).standardizedFileURL
        let relativePath = args[1]
        let file = vault.appendingPathComponent(relativePath)
        let agent = option("--agent", in: args) ?? "agent"
        let summary = option("--summary", in: args) ?? "Agent edit submitted for review"

        guard FileManager.default.fileExists(atPath: file.path) else {
            print("could not find \(file.path)")
            return
        }

        do {
            let metadataURL = try writeChangeMetadata(
                vault: vault,
                filePath: relativePath,
                agent: agent,
                summary: summary
            )
            print("change metadata written: \(metadataURL.path)")
            print("metadata format: manual ChangeMetadata-compatible JSON")
            writeSnapshot(vault: vault, file: file, reason: "Submitted agent change: \(summary)", source: agent)
        } catch {
            print("could not write change metadata: \(error.localizedDescription)")
        }
    }

    private static func snapshot(args: [String], source: String) {
        guard args.count >= 2 else {
            print("usage: graft-cli snapshot <vault> <file> --message \"Before edits\"")
            return
        }
        let vault = URL(fileURLWithPath: args[0]).standardizedFileURL
        let file = vault.appendingPathComponent(args[1])
        let message = option("--message", in: args) ?? "CLI checkpoint"
        writeSnapshot(vault: vault, file: file, reason: message, source: source)
    }

    private static func apply(args: [String]) {
        guard args.count >= 2 else {
            print("usage: graft-cli apply <vault> <file> --author codex")
            print("note: apply is a legacy snapshot-only alias; use submit-change to register review metadata")
            return
        }
        let vault = URL(fileURLWithPath: args[0]).standardizedFileURL
        let file = vault.appendingPathComponent(args[1])
        let author = option("--author", in: args) ?? "agent"
        writeSnapshot(vault: vault, file: file, reason: "External edit checkpoint by \(author)", source: author)
        print("note: apply is a legacy snapshot-only alias; use submit-change to register review metadata")
    }

    private static func history(args: [String]) {
        guard args.count >= 2 else {
            print("usage: graft-cli history <vault> <file>")
            return
        }
        let vault = URL(fileURLWithPath: args[0]).standardizedFileURL
        let safe = safeName(args[1])
        let folder = vault.appendingPathComponent(".graft/history/\(safe)", isDirectory: true)
        let snapshots = (try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: [.contentModificationDateKey])) ?? []
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
        let folder = vault.appendingPathComponent(".graft/changes", isDirectory: true)
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
            source: "graft-cli",
            createdAt: ISO8601DateFormatter().string(from: now)
        )
        let url = folder.appendingPathComponent("\(timestamp)-\(safeName(agent)).json")
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encoder.encode(metadata).write(to: url, options: [.atomic])
        return url
    }

    private static func writeSnapshot(vault: URL, file: URL, reason: String, source: String) {
        guard let content = try? String(contentsOf: file, encoding: .utf8) else {
            print("could not read \(file.path)")
            return
        }
        let relative = relativePath(for: file, in: vault)
        let folder = vault.appendingPathComponent(".graft/history/\(safeName(relative))", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss-SSS"
        let id = formatter.string(from: Date())
        let snapshotURL = folder.appendingPathComponent("\(id).md")
        let header = """
        ---
        graft_document: \(relative)
        graft_source: \(source)
        graft_reason: \(reason)
        graft_created_at: \(ISO8601DateFormatter().string(from: Date()))
        ---

        """
        do {
            try (header + content).write(to: snapshotURL, atomically: true, encoding: .utf8)
            print("snapshot \(id) written for \(relative)")
        } catch {
            print("could not write snapshot: \(error.localizedDescription)")
        }
    }

    private static func markdownFiles(in vault: URL) -> [URL] {
        guard let enumerator = FileManager.default.enumerator(at: vault, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) else {
            return []
        }
        return enumerator
            .compactMap { $0 as? URL }
            .map(\.standardizedFileURL)
            .filter { $0.pathExtension.lowercased() == "md" }
            .filter { !$0.path.contains("/.graft/") }
            .filter { $0.lastPathComponent != "AGENTS.md" }
            .sorted { $0.path < $1.path }
    }

    private static func changeMetadataFiles(in vault: URL, matching filePath: String? = nil) -> [URL] {
        let folder = vault.appendingPathComponent(".graft/changes", isDirectory: true)
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

    private static func relativePath(for file: URL, in vault: URL) -> String {
        let vaultPath = vault.standardizedFileURL.path
        let filePath = file.standardizedFileURL.path
        if filePath.hasPrefix(vaultPath + "/") {
            return String(filePath.dropFirst(vaultPath.count + 1))
        }
        return file.lastPathComponent
    }

    private static func safeName(_ path: String) -> String {
        path.replacingOccurrences(of: "/", with: "__")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ".", with: "_")
    }

    private static func timestampForFilename(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss-SSS"
        return formatter.string(from: date)
    }

    private static func printUsage() {
        print("""
        Graft CLI

        Commands:
          graft-cli status <vault>
          graft-cli submit-change <vault> <file> --agent codex --summary "Tightened welcome copy"
          graft-cli snapshot <vault> <file> --message "Before edits"
          graft-cli apply <vault> <file> --author codex  # legacy snapshot-only alias
          graft-cli history <vault> <file>
        """)
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

GraftCLI.main()
