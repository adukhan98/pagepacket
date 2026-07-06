import Foundation

public enum ChangeAuthorKind: String, Codable, Equatable {
    case human
    case agent
    case external
}

public enum ChangeReviewStatus: String, Codable, Equatable, Hashable, CaseIterable {
    case pending
    case accepted
    case rejected
    case conflict
}

public enum MarkdownBlockKind: String, Codable, Equatable {
    case heading
    case paragraph
    case list
    case task
    case quote
    case code
    case table
    case image
    case horizontalRule
    case unknown
}

public struct ChangeRange: Codable, Equatable, Identifiable {
    public let id: UUID
    public let oldStartLine: Int
    public let oldEndLine: Int
    public let newStartLine: Int
    public let newEndLine: Int
    public let kind: MarkdownBlockKind
    public let before: String
    public let after: String
    public let isConflict: Bool

    public init(
        id: UUID = UUID(),
        oldStartLine: Int,
        oldEndLine: Int,
        newStartLine: Int,
        newEndLine: Int,
        kind: MarkdownBlockKind,
        before: String,
        after: String,
        isConflict: Bool = false
    ) {
        self.id = id
        self.oldStartLine = oldStartLine
        self.oldEndLine = oldEndLine
        self.newStartLine = newStartLine
        self.newEndLine = newEndLine
        self.kind = kind
        self.before = before
        self.after = after
        self.isConflict = isConflict
    }
}

public struct ChangeSet: Codable, Equatable, Identifiable {
    public let id: UUID
    public let filePath: String
    public let authorName: String
    public let authorKind: ChangeAuthorKind
    public var status: ChangeReviewStatus
    public let summary: String
    public let createdAt: Date
    public let baseText: String
    public let proposedText: String
    public let ranges: [ChangeRange]

    public var hasConflicts: Bool {
        status == .conflict || ranges.contains { $0.isConflict }
    }

    public init(
        id: UUID = UUID(),
        filePath: String,
        authorName: String,
        authorKind: ChangeAuthorKind,
        status: ChangeReviewStatus,
        summary: String,
        createdAt: Date = Date(),
        baseText: String,
        proposedText: String,
        ranges: [ChangeRange]
    ) {
        self.id = id
        self.filePath = filePath
        self.authorName = authorName
        self.authorKind = authorKind
        self.status = status
        self.summary = summary
        self.createdAt = createdAt
        self.baseText = baseText
        self.proposedText = proposedText
        self.ranges = ranges
    }
}
