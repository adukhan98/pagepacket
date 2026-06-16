import Foundation

enum MarkdownBlock: Identifiable, Hashable {
    case heading(level: Int, text: String)
    case paragraph(String)
    case quote(String)
    case unorderedItem(String)
    case orderedItem(String)
    case task(done: Bool, text: String)
    case code(language: String?, text: String)
    case table(headers: [String], rows: [[String]])
    case image(alt: String, path: String)
    case horizontalRule

    var id: String {
        switch self {
        case let .heading(level, text): "heading-\(level)-\(text)"
        case let .paragraph(text): "paragraph-\(text)"
        case let .quote(text): "quote-\(text)"
        case let .unorderedItem(text): "ul-\(text)"
        case let .orderedItem(text): "ol-\(text)"
        case let .task(done, text): "task-\(done)-\(text)"
        case let .code(language, text): "code-\(language ?? "")-\(text)"
        case let .table(headers, rows): "table-\(headers.joined())-\(rows.flatMap { $0 }.joined())"
        case let .image(alt, path): "image-\(alt)-\(path)"
        case .horizontalRule: UUID().uuidString
        }
    }
}
