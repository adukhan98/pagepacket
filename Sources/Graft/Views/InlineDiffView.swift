import GraftCore
import SwiftUI

struct InlineDiffView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    let changeSet: ChangeSet
    let onAccept: () -> Void
    let onReject: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Label(
                    changeSet.summary,
                    systemImage: changeSet.status == .conflict ? "exclamationmark.triangle" : "sparkles"
                )
                .font(.headline)
                .foregroundStyle(GraftTheme.ink)

                Spacer()

                Button("Reject all", action: onReject)
                Button("Accept all", action: onAccept)
                    .buttonStyle(.borderedProminent)
            }

            HStack(spacing: 8) {
                Text("\(changeSet.authorName) edited \(changeSet.filePath)")
                Text("•")
                Text(hunkCountLabel)
                if changeSet.hasConflicts {
                    Text("Conflict")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(GraftTheme.pink)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(GraftTheme.pink.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
            .font(.caption)
            .foregroundStyle(GraftTheme.muted)

            ForEach(changeSet.ranges) { range in
                if changeSet.status == .conflict || range.isConflict {
                    ConflictResolutionView(
                        range: range,
                        onKeepCurrent: { workspace.reject(range, from: changeSet) },
                        onUseProposed: { workspace.accept(range, from: changeSet) }
                    )
                    .padding(.top, 4)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(range.kind.rawValue) \(lineLabel(for: range))")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(GraftTheme.muted)

                            Spacer()

                            Button("Reject hunk") {
                                workspace.reject(range, from: changeSet)
                            }

                            Button("Accept hunk") {
                                workspace.accept(range, from: changeSet)
                            }
                            .buttonStyle(.bordered)
                        }

                        if !range.before.isEmpty {
                            DiffBlock(label: "Current", text: range.before, tint: GraftTheme.pink.opacity(0.14))
                        }

                        if !range.after.isEmpty {
                            DiffBlock(label: "Proposed", text: range.after, tint: GraftTheme.mint.opacity(0.24))
                        }
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding(14)
        .background(GraftTheme.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(changeSet.status == .conflict ? GraftTheme.pink : GraftTheme.line, lineWidth: 1)
        }
    }

    private var hunkCountLabel: String {
        "\(changeSet.ranges.count) \(changeSet.ranges.count == 1 ? "hunk" : "hunks")"
    }

    private func lineLabel(for range: ChangeRange) -> String {
        if range.oldStartLine == range.oldEndLine {
            "line \(range.oldStartLine)"
        } else {
            "lines \(range.oldStartLine)-\(range.oldEndLine)"
        }
    }
}

private struct DiffBlock: View {
    let label: String
    let text: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(GraftTheme.muted)
            Text(text)
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
