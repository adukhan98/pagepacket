import Foundation

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
            print("missing vault path")
            return
        }
        let files = markdownFiles(in: vault)
        print("Pagepacket vault: \(vault.path)")
        print("Markdown files: \(files.count)")
        print("Sidecar: \(vault.appendingPathComponent(".pagepacket").path)")
        files.prefix(12).forEach { print("- \(relativePath(from: vault, to: $0))") }
    }

    private static func snapshot(args: [String], source: String) {
        guard args.count >= 2 else {
            print("usage: pagepacket-cli snapshot <vault> <file> --message \"Before edits\"")
            return
        }
        let vault = normalized(URL(fileURLWithPath: args[0]))
        let file = normalized(vault.appendingPathComponent(args[1]))
        let message = option("--message", in: args) ?? "CLI checkpoint"
        writeSnapshot(vault: vault, file: file, reason: message, source: source)
    }

    private static func apply(args: [String]) {
        guard args.count >= 2 else {
            print("usage: pagepacket-cli apply <vault> <file> --author codex")
            return
        }
        let vault = normalized(URL(fileURLWithPath: args[0]))
        let file = normalized(vault.appendingPathComponent(args[1]))
        let author = option("--author", in: args) ?? "agent"
        writeSnapshot(vault: vault, file: file, reason: "Applied external edit by \(author)", source: author)
    }

    private static func history(args: [String]) {
        guard args.count >= 2 else {
            print("usage: pagepacket-cli history <vault> <file>")
            return
        }
        let vault = normalized(URL(fileURLWithPath: args[0]))
        let folders = [
            vault.appendingPathComponent(".pagepacket/history/\(historyFolderName(for: args[1]))", isDirectory: true),
            vault.appendingPathComponent(".pagepacket/history/\(legacyHistoryFolderName(for: args[1]))", isDirectory: true)
        ]
        let snapshots = folders.flatMap { folder in
            (try? FileManager.default.contentsOfDirectory(
                at: folder,
                includingPropertiesForKeys: [.contentModificationDateKey]
            )) ?? []
        }
        guard !snapshots.isEmpty else {
            print("No snapshots for \(args[1])")
            return
        }
        for url in snapshots.sorted(by: { $0.lastPathComponent > $1.lastPathComponent }) {
            print(url.deletingPathExtension().lastPathComponent)
        }
    }

    private static func writeSnapshot(vault: URL, file: URL, reason: String, source: String) {
        guard let content = try? String(contentsOf: file, encoding: .utf8) else {
            print("could not read \(file.path)")
            return
        }
        let relative = relativePath(from: vault, to: file)
        let folder = vault.appendingPathComponent(".pagepacket/history/\(historyFolderName(for: relative))", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss-SSS"
        let timestamp = Date()
        let id = formatter.string(from: timestamp)
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
            print("could not write snapshot: \(error.localizedDescription)")
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
            .sorted { $0.path < $1.path }
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

    private static func printUsage() {
        print("""
        Pagepacket CLI

        Commands:
          pagepacket-cli status <vault>
          pagepacket-cli snapshot <vault> <file> --message "Before edits"
          pagepacket-cli apply <vault> <file> --author codex
          pagepacket-cli history <vault> <file>
        """)
    }
}

PagepacketCLI.main()
