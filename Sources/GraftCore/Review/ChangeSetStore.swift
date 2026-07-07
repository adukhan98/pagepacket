import Foundation

public struct ChangeSetStore {
    public let workspaceURL: URL

    public init(workspaceURL: URL) {
        self.workspaceURL = workspaceURL
    }

    public var reviewsURL: URL {
        workspaceURL.appendingPathComponent(".pagepacket/reviews", isDirectory: true)
    }

    public func write(_ changeSet: ChangeSet) throws {
        let folder = folderURL(for: changeSet.status)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let url = folder.appendingPathComponent("\(changeSet.id.uuidString).json")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encoder.encode(changeSet).write(to: url, options: .atomic)
    }

    public func loadAll() throws -> [ChangeSet] {
        try ChangeReviewStatus.allCases.flatMap { status in
            try load(status: status)
        }
        .sorted { $0.createdAt < $1.createdAt }
    }

    public func load(status: ChangeReviewStatus) throws -> [ChangeSet] {
        let folder = folderURL(for: status)
        guard FileManager.default.fileExists(atPath: folder.path) else {
            return []
        }

        let urls = try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try urls
            .filter { $0.pathExtension == "json" }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }
            .map { url in
                try decoder.decode(ChangeSet.self, from: Data(contentsOf: url))
            }
    }

    public func delete(_ changeSet: ChangeSet) throws {
        let url = folderURL(for: changeSet.status)
            .appendingPathComponent("\(changeSet.id.uuidString).json")
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        try FileManager.default.removeItem(at: url)
    }

    public func deleteMatching(filePath: String, statuses: Set<ChangeReviewStatus>) throws {
        for status in statuses {
            for changeSet in try load(status: status) where changeSet.filePath == filePath {
                try delete(changeSet)
            }
        }
    }

    public func folderURL(for status: ChangeReviewStatus) -> URL {
        reviewsURL.appendingPathComponent(status.rawValue, isDirectory: true)
    }
}
