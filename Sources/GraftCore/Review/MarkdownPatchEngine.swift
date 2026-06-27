import Foundation

public enum MarkdownPatchError: Error, Equatable {
    case invalidLineRange
    case staleHunk
}

public struct MarkdownPatchEngine {
    public init() {}

    public func apply(_ range: ChangeRange, to markdown: String) throws -> String {
        var lines = markdown.components(separatedBy: .newlines)

        if range.before.isEmpty {
            let insertionIndex = max(0, min(lines.count, range.oldStartLine - 1))
            lines.insert(contentsOf: replacementLines(for: range.after), at: insertionIndex)
            return lines.joined(separator: "\n")
        }

        let start = range.oldStartLine - 1
        let end = range.oldEndLine - 1
        guard start >= 0, end >= start, end < lines.count else {
            throw MarkdownPatchError.invalidLineRange
        }

        let targetRange = matchingRange(
            for: range.before,
            preferredStart: start,
            preferredEnd: end,
            in: lines
        )
        guard let targetRange else {
            throw MarkdownPatchError.staleHunk
        }

        if range.after.isEmpty {
            lines.removeSubrange(targetRange)
            collapseDuplicateBlankLine(around: targetRange.lowerBound, in: &lines)
        } else {
            lines.replaceSubrange(targetRange, with: replacementLines(for: range.after))
        }

        return lines.joined(separator: "\n")
    }

    private func matchingRange(
        for before: String,
        preferredStart: Int,
        preferredEnd: Int,
        in lines: [String]
    ) -> ClosedRange<Int>? {
        let preferredBlock = lines[preferredStart...preferredEnd].joined(separator: "\n")
        if preferredBlock == before {
            return preferredStart...preferredEnd
        }

        let beforeLines = replacementLines(for: before)
        guard !beforeLines.isEmpty, beforeLines.count <= lines.count else {
            return nil
        }

        let matches = (0...(lines.count - beforeLines.count)).compactMap { index -> ClosedRange<Int>? in
            let end = index + beforeLines.count - 1
            return Array(lines[index...end]) == beforeLines ? index...end : nil
        }

        return matches.count == 1 ? matches[0] : nil
    }

    private func replacementLines(for text: String) -> [String] {
        text.components(separatedBy: .newlines)
    }

    private func collapseDuplicateBlankLine(around index: Int, in lines: inout [String]) {
        guard index > 0, index < lines.count else {
            return
        }

        if lines[index - 1].isEmpty && lines[index].isEmpty {
            lines.remove(at: index)
        }
    }
}
