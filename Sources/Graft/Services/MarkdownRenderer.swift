import Foundation

struct MarkdownRenderer {
    func blocks(from markdown: String) -> [MarkdownBlock] {
        var blocks: [MarkdownBlock] = []
        let lines = markdown.components(separatedBy: .newlines)
        var index = 0

        while index < lines.count {
            let startLine = index
            let line = lines[index]
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if trimmed.isEmpty {
                index += 1
                continue
            }

            if trimmed.hasPrefix("```") {
                let language = String(trimmed.dropFirst(3)).nilIfEmpty
                index += 1
                var codeLines: [String] = []
                while index < lines.count, !lines[index].trimmingCharacters(in: .whitespaces).hasPrefix("```") {
                    codeLines.append(lines[index])
                    index += 1
                }
                blocks.append(block(startLine: startLine, kind: .code(language: language, text: codeLines.joined(separator: "\n"))))
                index += 1
                continue
            }

            if index + 1 < lines.count,
               isTableRow(trimmed),
               isTableSeparator(lines[index + 1].trimmingCharacters(in: .whitespaces)) {
                let headers = parseTableCells(trimmed)
                index += 2
                var rows: [[String]] = []
                while index < lines.count {
                    let row = lines[index].trimmingCharacters(in: .whitespaces)
                    guard isTableRow(row), !row.isEmpty else { break }
                    rows.append(parseTableCells(row))
                    index += 1
                }
                blocks.append(block(startLine: startLine, kind: .table(headers: headers, rows: rows)))
                continue
            }

            if let image = parseImage(trimmed) {
                blocks.append(block(startLine: startLine, kind: image))
            } else if trimmed == "---" || trimmed == "***" {
                blocks.append(block(startLine: startLine, kind: .horizontalRule))
            } else if trimmed.hasPrefix("#") {
                let level = min(trimmed.prefix(while: { $0 == "#" }).count, 6)
                let text = trimmed.dropFirst(level).trimmingCharacters(in: .whitespaces)
                blocks.append(block(startLine: startLine, kind: .heading(level: level, text: String(text))))
            } else if trimmed.hasPrefix(">") {
                blocks.append(block(startLine: startLine, kind: .quote(String(trimmed.dropFirst()).trimmingCharacters(in: .whitespaces))))
            } else if trimmed.hasPrefix("- [ ] ") || trimmed.hasPrefix("* [ ] ") {
                blocks.append(block(startLine: startLine, kind: .task(done: false, text: String(trimmed.dropFirst(6)))))
            } else if trimmed.hasPrefix("- [x] ") || trimmed.hasPrefix("* [x] ") || trimmed.hasPrefix("- [X] ") || trimmed.hasPrefix("* [X] ") {
                blocks.append(block(startLine: startLine, kind: .task(done: true, text: String(trimmed.dropFirst(6)))))
            } else if trimmed.hasPrefix("- ") || trimmed.hasPrefix("* ") {
                blocks.append(block(startLine: startLine, kind: .unorderedItem(String(trimmed.dropFirst(2)))))
            } else if let ordered = orderedItem(trimmed) {
                blocks.append(block(startLine: startLine, kind: .orderedItem(number: ordered.number, text: ordered.text)))
            } else {
                var paragraphLines = [trimmed]
                index += 1
                while index < lines.count {
                    let nextLine = lines[index]
                    let next = nextLine.trimmingCharacters(in: .whitespaces)
                    guard !next.isEmpty, !startsBlock(next) else { break }
                    paragraphLines.append(next)
                    index += 1
                }
                blocks.append(block(startLine: startLine, kind: .paragraph(paragraphLines.joined(separator: " "))))
                continue
            }

            index += 1
        }

        return blocks
    }

    private func block(startLine: Int, kind: MarkdownPreviewBlockKind) -> MarkdownBlock {
        MarkdownBlock(id: "line-\(startLine)-\(kind.identityPrefix)", kind: kind)
    }

    private func parseImage(_ line: String) -> MarkdownPreviewBlockKind? {
        guard line.hasPrefix("!["),
              let closeAlt = line.firstIndex(of: "]"),
              line[line.index(after: closeAlt)...].hasPrefix("("),
              line.hasSuffix(")") else {
            return nil
        }

        let alt = String(line[line.index(line.startIndex, offsetBy: 2)..<closeAlt])
        let pathStart = line.index(closeAlt, offsetBy: 2)
        let pathEnd = line.index(before: line.endIndex)
        let rawDestination = String(line[pathStart..<pathEnd])
        let path = normalizedImagePath(rawDestination)
        guard !path.isEmpty else { return nil }
        return .image(alt: alt, path: path)
    }

    private func normalizedImagePath(_ rawDestination: String) -> String {
        var destination = rawDestination.trimmingCharacters(in: .whitespacesAndNewlines)
        if let quoteRange = destination.range(of: #"[\s]+"[^"]*"\s*$"#, options: .regularExpression) {
            destination.removeSubrange(quoteRange)
        }
        if let titleRange = destination.range(of: #"\s+'[^']*'\s*$"#, options: .regularExpression) {
            destination.removeSubrange(titleRange)
        }
        destination = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        if destination.hasPrefix("<"), destination.hasSuffix(">") {
            destination.removeFirst()
            destination.removeLast()
        }
        if destination.hasPrefix("./") {
            destination.removeFirst(2)
        }
        return destination.removingPercentEncoding ?? destination
    }

    private func orderedItem(_ line: String) -> (number: Int, text: String)? {
        guard let dot = line.firstIndex(of: ".") else { return nil }
        let prefix = line[..<dot]
        guard !prefix.isEmpty,
              prefix.allSatisfy(\.isNumber),
              let number = Int(prefix) else {
            return nil
        }
        let text = line[line.index(after: dot)...].trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return nil }
        return (number, text)
    }

    private func startsBlock(_ trimmed: String) -> Bool {
        trimmed.hasPrefix("```")
            || trimmed.hasPrefix("#")
            || trimmed.hasPrefix(">")
            || trimmed.hasPrefix("- ")
            || trimmed.hasPrefix("* ")
            || trimmed.hasPrefix("- [ ] ")
            || trimmed.hasPrefix("* [ ] ")
            || trimmed.hasPrefix("- [x] ")
            || trimmed.hasPrefix("* [x] ")
            || trimmed.hasPrefix("- [X] ")
            || trimmed.hasPrefix("* [X] ")
            || orderedItem(trimmed) != nil
            || parseImage(trimmed) != nil
            || trimmed == "---"
            || trimmed == "***"
            || isTableRow(trimmed)
    }

    private func isTableRow(_ line: String) -> Bool {
        line.contains("|") && line.split(separator: "|", omittingEmptySubsequences: false).count > 1
    }

    private func isTableSeparator(_ line: String) -> Bool {
        guard isTableRow(line) else { return false }
        return parseTableCells(line).allSatisfy { cell in
            let cleaned = cell.replacingOccurrences(of: ":", with: "")
            return !cleaned.isEmpty && cleaned.allSatisfy { $0 == "-" }
        }
    }

    private func parseTableCells(_ line: String) -> [String] {
        var trimmed = line.trimmingCharacters(in: .whitespaces)
        if trimmed.hasPrefix("|") {
            trimmed.removeFirst()
        }
        if trimmed.hasSuffix("|") {
            trimmed.removeLast()
        }
        return trimmed
            .split(separator: "|", omittingEmptySubsequences: false)
            .map { String($0).trimmingCharacters(in: .whitespaces) }
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}

private extension MarkdownPreviewBlockKind {
    var identityPrefix: String {
        switch self {
        case .heading: "heading"
        case .paragraph: "paragraph"
        case .quote: "quote"
        case .unorderedItem: "ul"
        case .orderedItem: "ol"
        case .task: "task"
        case .code: "code"
        case .table: "table"
        case .image: "image"
        case .horizontalRule: "hr"
        }
    }
}
