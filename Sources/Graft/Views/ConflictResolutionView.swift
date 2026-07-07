import GraftCore
import SwiftUI

struct ConflictResolutionView: View {
    let range: ChangeRange
    let onKeepCurrent: () -> Void
    let onUseProposed: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Conflict", systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
                .foregroundStyle(GraftTheme.pink)

            HStack(alignment: .top, spacing: 12) {
                ConflictColumn(
                    title: "Human draft",
                    text: range.before,
                    tint: GraftTheme.pink.opacity(0.12)
                )
                ConflictColumn(
                    title: "Agent proposal",
                    text: range.after,
                    tint: GraftTheme.mint.opacity(0.20)
                )
            }

            HStack {
                Spacer()
                Button("Keep draft", action: onKeepCurrent)
                Button("Use proposal", action: onUseProposed)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(12)
        .background(GraftTheme.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(GraftTheme.pink.opacity(0.5), lineWidth: 1)
        }
    }
}

private struct ConflictColumn: View {
    let title: String
    let text: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(GraftTheme.muted)
            Text(text.isEmpty ? "Empty block" : text)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(GraftTheme.ink)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(tint)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}
