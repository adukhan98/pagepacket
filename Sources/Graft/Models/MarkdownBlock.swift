import Foundation

enum MarkdownBlock: Hashable {
    case heading(level: Int, text: String)
    case paragraph(String)
    case quote(String)
    case unorderedItem(depth: Int, text: String)
    case orderedItem(number: Int, depth: Int, text: String)
    case task(done: Bool, depth: Int, text: String)
    case code(language: String?, text: String)
    case table(headers: [String], rows: [[String]])
    case image(alt: String, path: String)
    case horizontalRule
}
