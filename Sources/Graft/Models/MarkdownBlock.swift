import Foundation

struct MarkdownBlock: Identifiable, Hashable {
    let id: String
    let kind: MarkdownBlockKind
}

enum MarkdownBlockKind: Hashable {
    case heading(level: Int, text: String)
    case paragraph(String)
    case quote(String)
    case unorderedItem(String)
    case orderedItem(number: Int, text: String)
    case task(done: Bool, text: String)
    case code(language: String?, text: String)
    case table(headers: [String], rows: [[String]])
    case image(alt: String, path: String)
    case horizontalRule
}
