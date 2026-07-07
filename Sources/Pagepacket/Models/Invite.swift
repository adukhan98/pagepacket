import Foundation

enum InviteRole: String, CaseIterable, Identifiable, Codable {
    case viewer
    case commenter
    case editor

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }
}

struct Invite: Identifiable, Hashable, Codable {
    var id = UUID()
    var email: String
    var role: InviteRole
    var createdAt: Date = Date()
}
