import AppKit
import SwiftUI

enum PagepacketTheme {
    static let canvas = Color(hex: 0xFFFAF0)
    static let surfaceSoft = Color(hex: 0xFAF5E8)
    static let surfaceCard = Color(hex: 0xF5F0E0)
    static let ink = Color(hex: 0x0A0A0A)
    static let body = Color(hex: 0x3A3A3A)
    static let muted = Color(hex: 0x6A6A6A)
    static let pink = Color(hex: 0xFF4D8B)
    static let teal = Color(hex: 0x1A3A3A)
    static let lavender = Color(hex: 0xB8A4ED)
    static let peach = Color(hex: 0xFFB084)
    static let ochre = Color(hex: 0xE8B94A)
    static let mint = Color(hex: 0xA4D4C5)
    static let divider = Color.black.opacity(0.14)
    static let statusBar = Color(hex: 0x8B8577)

    static let nsCanvas = NSColor(hex: 0xFFFAF0)
    static let nsBody = NSColor(hex: 0x3A3A3A)
    static let nsInk = NSColor(hex: 0x0A0A0A)
    static let nsSelection = NSColor(hex: 0xA4D4C5, alpha: 0.42)

    static func accent(_ name: String) -> Color {
        switch name {
        case "pink": pink
        case "teal": teal
        case "lavender": lavender
        case "peach": peach
        case "ochre": ochre
        default: mint
        }
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension NSColor {
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            calibratedRed: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue: CGFloat(hex & 0xff) / 255,
            alpha: alpha
        )
    }
}

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .foregroundStyle(PagepacketTheme.body)
            .background(PagepacketTheme.surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(PagepacketTheme.divider.opacity(0.75), lineWidth: 1)
            }
    }
}

extension View {
    func pagepacketCard() -> some View {
        modifier(CardBackground())
    }
}
