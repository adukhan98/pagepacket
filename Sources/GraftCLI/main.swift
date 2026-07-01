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
        guard let vault = args.first.map(URL.init(fileURLWithPath:)) else {
            print("missing vault path")
            return
        }
        let files = markdownFiles(in: vault)
        print("Pagepacket vault: \(vault.path)")
        print("Markdown files: \(files.count)")
        print("Sidecar: \(vault.appendingPathComponent(".pagepacket").path)")
        files.prefix(12).forEach { print("- \($0.path.replacingOccurrences(of: vault.path + "/", with: ""))") }
    }

    private static func snapshot(args: [String], source: String) {
        guard args.count >= 2 else {
            print("usage: pagepacket-cli snapshot <vault> <file> --message \"Before edits\"")
            return
        }
        let vault = URL(fileURLWithPath: args[0])
        let file = vault.appendingPathComponent(args[1])
        let message = option("--message", in: args) ?? "CLI checkpoint"
        writeSnapshot(vault: vault, file: file, reason: message, source: source)
    }

    private static func apply(args: [String]) {
        guard args.count >= 2 else {
            print("usage: pagepacket-cli apply <vault> <file> --author codex")
            return
        }
        let vault = URL(fileURLWithPath: args[0])
        let file = vault.appendingPathComponent(args[1])
        let author = option("--author", in: args) ?? "agent"
        writeSnapshot(vault: vault, file: file, reason: "Applied external edit by \(author)", source: author)
    }

    private static func history(args: [String]) {
        guard args.count >= 2 else {
            print("usage: pagepacket-cli history <vault> <file>")
            return
        }
        let vault = URL(fileURLWithPath: args[0])
        let safe = safeName(args[1])
        let folder = vault.appendingPathComponent(".pagepacket/history/\(safe)", isDirectory: true)
        guard let snapshots = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: [.contentModificationDateKey]) else {
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
        let relative = file.path.replacingOccurrences(of: vault.path + "/", with: "")
        let folder = vault.appendingPathComponent(".pagepacket/history/\(safeName(relative))", isDirectory: true)
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

    private static func safeName(_ path: String) -> String {
        path.replacingOccurrences(of: "/", with: "__")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ".", with: "_")
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
