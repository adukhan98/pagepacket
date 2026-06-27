import SwiftUI

enum GraftTheme {
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
    static let line = Color.black.opacity(0.10)
    static let controlFill = Color.white.opacity(0.62)
    static let selectedFill = Color(hex: 0x1A3A3A)

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

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(GraftTheme.surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.black.opacity(0.08), lineWidth: 1)
            }
    }
}

extension View {
    func graftCard() -> some View {
        modifier(CardBackground())
    }

    func graftPanelBackground() -> some View {
        background(GraftTheme.surfaceSoft)
            .foregroundStyle(GraftTheme.body)
    }

    func graftReadableField() -> some View {
        padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(GraftTheme.controlFill)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .stroke(GraftTheme.line, lineWidth: 1)
            }
    }
}

struct GraftSegmentedControl<Selection: Hashable>: View {
    let items: [(Selection, String)]
    @Binding var selection: Selection

    var body: some View {
        HStack(spacing: 2) {
            ForEach(items, id: \.0) { value, title in
                Button {
                    selection = value
                } label: {
                    Text(title)
                        .font(.caption.weight(.semibold))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .foregroundStyle(selection == value ? Color.white : GraftTheme.ink)
                        .background(selection == value ? GraftTheme.selectedFill : Color.clear)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(GraftTheme.surfaceCard)
        .clipShape(Capsule())
        .overlay {
            Capsule()
                .stroke(GraftTheme.line, lineWidth: 1)
        }
    }
}
