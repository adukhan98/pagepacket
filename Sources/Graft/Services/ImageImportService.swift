import AppKit
import Foundation

struct ImageImportService {
    let workspaceURL: URL

    func importImage(from sourceURL: URL, for file: MarkdownFile) -> String? {
        let normalizedWorkspaceURL = PathUtilities.normalized(workspaceURL)
        let folderName = file.url.deletingPathExtension().lastPathComponent
        let assetFolder = normalizedWorkspaceURL
            .appendingPathComponent("assets", isDirectory: true)
            .appendingPathComponent(folderName, isDirectory: true)
        try? FileManager.default.createDirectory(at: assetFolder, withIntermediateDirectories: true)

        let baseName = sourceURL.deletingPathExtension().lastPathComponent
        let ext = sourceURL.pathExtension.isEmpty ? "png" : sourceURL.pathExtension
        let destination = assetFolder.appendingPathComponent("\(baseName)-\(Int(Date().timeIntervalSince1970)).\(ext)")

        do {
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destination)
            let relative = PathUtilities.relativePath(from: file.url.deletingLastPathComponent(), to: destination)
            return "![\(baseName)](\(relative))"
        } catch {
            return nil
        }
    }
}
