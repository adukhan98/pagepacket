import Foundation

public struct MarkdownDiffEngine {
    public init() {}

    public func changedRanges(before: String, after: String) -> [ChangeRange] {
        guard before != after else {
            return []
        }

        let oldBlocks = Self.blocks(in: before)
        let newBlocks = Self.blocks(in: after)
        let matches = Self.longestCommonSubsequence(oldBlocks, newBlocks)
        var ranges: [ChangeRange] = []
        var oldIndex = 0
        var newIndex = 0

        for match in matches {
            ranges.append(contentsOf: Self.ranges(
                oldBlocks: Array(oldBlocks[oldIndex..<match.oldIndex]),
                newBlocks: Array(newBlocks[newIndex..<match.newIndex])
            ))
            oldIndex = match.oldIndex + 1
            newIndex = match.newIndex + 1
        }

        ranges.append(contentsOf: Self.ranges(
            oldBlocks: Array(oldBlocks[oldIndex..<oldBlocks.count]),
            newBlocks: Array(newBlocks[newIndex..<newBlocks.count])
        ))

        return ranges
    }

    private static func ranges(oldBlocks: [MarkdownBlock], newBlocks: [MarkdownBlock]) -> [ChangeRange] {
        let count = max(oldBlocks.count, newBlocks.count)
        guard count > 0 else {
            return []
        }

        return (0..<count).map { index in
            let oldBlock = index < oldBlocks.count ? oldBlocks[index] : nil
            let newBlock = index < newBlocks.count ? newBlocks[index] : nil
            let representative = newBlock ?? oldBlock

            return ChangeRange(
                oldStartLine: oldBlock?.startLine ?? oldInsertionLine(relativeTo: representative),
                oldEndLine: oldBlock?.endLine ?? oldInsertionLine(relativeTo: representative),
                newStartLine: newBlock?.startLine ?? newInsertionLine(relativeTo: representative),
                newEndLine: newBlock?.endLine ?? newInsertionLine(relativeTo: representative),
                kind: kind(for: representative?.text ?? ""),
                before: oldBlock?.text ?? "",
                after: newBlock?.text ?? ""
            )
        }
    }

    private static func oldInsertionLine(relativeTo block: MarkdownBlock?) -> Int {
        max(1, block?.startLine ?? 1)
    }

    private static func newInsertionLine(relativeTo block: MarkdownBlock?) -> Int {
        max(1, block?.startLine ?? 1)
    }

    private static func blocks(in markdown: String) -> [MarkdownBlock] {
        let lines = markdown.components(separatedBy: .newlines)
        var blocks: [MarkdownBlock] = []
        var index = 0

        while index < lines.count {
            while index < lines.count && lines[index].trimmingCharacters(in: .whitespaces).isEmpty {
                index += 1
            }
            guard index < lines.count else {
                break
            }

            let start = index
            if lines[index].trimmingCharacters(in: .whitespaces).hasPrefix("```") {
                index += 1
                while index < lines.count {
                    let trimmed = lines[index].trimmingCharacters(in: .whitespaces)
                    index += 1
                    if trimmed.hasPrefix("```") {
                        break
                    }
                }
            } else {
                index += 1
                while index < lines.count && !lines[index].trimmingCharacters(in: .whitespaces).isEmpty {
                    index += 1
                }
            }

            let text = lines[start..<index].joined(separator: "\n")
            blocks.append(MarkdownBlock(text: text, startLine: start + 1, endLine: index))
        }

        return blocks
    }

    private static func longestCommonSubsequence(
        _ oldBlocks: [MarkdownBlock],
        _ newBlocks: [MarkdownBlock]
    ) -> [(oldIndex: Int, newIndex: Int)] {
        let oldCount = oldBlocks.count
        let newCount = newBlocks.count
        var lengths = Array(repeating: Array(repeating: 0, count: newCount + 1), count: oldCount + 1)

        for oldIndex in stride(from: oldCount - 1, through: 0, by: -1) where oldCount > 0 {
            for newIndex in stride(from: newCount - 1, through: 0, by: -1) where newCount > 0 {
                if oldBlocks[oldIndex].text == newBlocks[newIndex].text {
                    lengths[oldIndex][newIndex] = lengths[oldIndex + 1][newIndex + 1] + 1
                } else {
                    lengths[oldIndex][newIndex] = max(lengths[oldIndex + 1][newIndex], lengths[oldIndex][newIndex + 1])
                }
            }
        }

        var oldIndex = 0
        var newIndex = 0
        var matches: [(oldIndex: Int, newIndex: Int)] = []
        while oldIndex < oldCount && newIndex < newCount {
            if oldBlocks[oldIndex].text == newBlocks[newIndex].text {
                matches.append((oldIndex, newIndex))
                oldIndex += 1
                newIndex += 1
            } else if lengths[oldIndex + 1][newIndex] >= lengths[oldIndex][newIndex + 1] {
                oldIndex += 1
            } else {
                newIndex += 1
            }
        }

        return matches
    }

    private static func kind(for text: String) -> MarkdownBlockKind {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("#") { return .heading }
        if trimmed.hasPrefix("```") { return .code }
        if trimmed.hasPrefix(">") { return .quote }
        if trimmed.hasPrefix("![") { return .image }
        if trimmed.hasPrefix("- [ ]") || trimmed.hasPrefix("- [x]") { return .task }
        if trimmed.hasPrefix("- ") || trimmed.hasPrefix("* ") { return .list }
        if trimmed.contains("|") { return .table }
        if trimmed == "---" || trimmed == "***" { return .horizontalRule }
        if trimmed.isEmpty { return .unknown }
        return .paragraph
    }
}

private struct MarkdownBlock: Equatable {
    let text: String
    let startLine: Int
    let endLine: Int
}
