import Foundation

@MainActor
final class FileWatcher {
    private var timer: Timer?
    private var knownDates: [URL: Date] = [:]
    private let fileManager = FileManager.default

    func start(watching files: [MarkdownFile], onChange: @escaping @MainActor (URL) -> Void) {
        stop()
        knownDates = Dictionary(uniqueKeysWithValues: files.map { ($0.url, $0.modifiedAt) })
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                for url in self.knownDates.keys {
                    guard self.fileManager.fileExists(atPath: url.path),
                          let modifiedAt = try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate else {
                        continue
                    }
                    if let known = self.knownDates[url], modifiedAt > known {
                        self.knownDates[url] = modifiedAt
                        onChange(url)
                    }
                }
            }
        }
    }

    func update(files: [MarkdownFile]) {
        knownDates = Dictionary(uniqueKeysWithValues: files.map { ($0.url, $0.modifiedAt) })
    }

    func markClean(_ url: URL) {
        if let modifiedAt = try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate {
            knownDates[url] = modifiedAt
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
