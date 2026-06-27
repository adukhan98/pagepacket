import AppKit
import Foundation

struct ImageImportService {
    let workspaceURL: URL

    func importImage(from sourceURL: URL, for file: MarkdownFile) -> String? {
        let assetFolder = assetFolder(for: file)
        try? FileManager.default.createDirectory(at: assetFolder, withIntermediateDirectories: true)

        let baseName = sanitizedName(sourceURL.deletingPathExtension().lastPathComponent)
        let ext = sourceURL.pathExtension.isEmpty ? "png" : sourceURL.pathExtension
        let destination = availableURL(in: assetFolder, filename: "\(baseName).\(ext)")

        do {
            try FileManager.default.copyItem(at: sourceURL, to: destination)
            let relative = relativePath(from: file.url.deletingLastPathComponent(), to: destination)
            return "![\(baseName)](\(relative))"
        } catch {
            return nil
        }
    }

    private func assetFolder(for file: MarkdownFile) -> URL {
        let documentPath = file.relativePath
            .replacingOccurrences(of: "\\.md$", with: "", options: .regularExpression)
            .split(separator: "/")
            .map { sanitizedName(String($0)) }

        return documentPath.reduce(workspaceURL.appendingPathComponent("assets", isDirectory: true)) { folder, component in
            folder.appendingPathComponent(component, isDirectory: true)
        }
    }

    private func availableURL(in folder: URL, filename: String) -> URL {
        let original = folder.appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: original.path) else {
            return original
        }

        let ext = original.pathExtension
        let stem = original.deletingPathExtension().lastPathComponent
        var index = 2

        while true {
            let candidateName = ext.isEmpty ? "\(stem)-\(index)" : "\(stem)-\(index).\(ext)"
            let candidate = folder.appendingPathComponent(candidateName)
            if !FileManager.default.fileExists(atPath: candidate.path) {
                return candidate
            }
            index += 1
        }
    }

    private func sanitizedName(_ name: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_"))
        let collapsed = name.unicodeScalars.map { allowed.contains($0) ? String($0) : "-" }
            .joined()
            .replacingOccurrences(of: "-+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
        return collapsed.isEmpty ? "image" : collapsed
    }

    private func relativePath(from folder: URL, to destination: URL) -> String {
        let fromComponents = folder.standardizedFileURL.pathComponents
        let toComponents = destination.standardizedFileURL.pathComponents
        let commonCount = zip(fromComponents, toComponents).prefix { $0 == $1 }.count
        let up = Array(repeating: "..", count: max(0, fromComponents.count - commonCount))
        let down = Array(toComponents.dropFirst(commonCount))
        return (up + down).joined(separator: "/")
    }
}
