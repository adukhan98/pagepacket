import Foundation

enum PathUtilities {
    static func normalized(_ url: URL) -> URL {
        url.standardizedFileURL.resolvingSymlinksInPath()
    }

    static func relativePath(from baseDirectory: URL, to target: URL) -> String {
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

    static func historyFolderName(for path: String) -> String {
        "\(legacyHistoryFolderName(for: path))__\(hexEncoded(path))"
    }

    static func legacyHistoryFolderName(for path: String) -> String {
        path.replacingOccurrences(of: "/", with: "__")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ".", with: "_")
    }

    private static func hexEncoded(_ path: String) -> String {
        path.utf8.map { String(format: "%02x", $0) }.joined()
    }
}
