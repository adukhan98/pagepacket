import Foundation

enum AgentKind: String, CaseIterable, Identifiable {
    case codex = "Codex"
    case claude = "Claude Code"
    case cursor = "Cursor"
    case hermes = "Hermes"
    case shell = "Shell"

    var id: String { rawValue }
}

struct AgentActivity: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var status: String
    var detail: String
    var accentName: String
}
