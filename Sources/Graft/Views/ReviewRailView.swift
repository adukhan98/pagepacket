import GraftCore
import SwiftUI

struct ReviewRailView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Agent Edits")
                        .font(.headline)
                        .foregroundStyle(GraftTheme.ink)
                    Text(fileContext)
                        .font(.caption2)
                        .foregroundStyle(GraftTheme.muted)
                        .lineLimit(1)
                }
                Spacer()
                if !workspace.pendingChangeSets.isEmpty {
                    Text("\(workspace.pendingChangeSets.count)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(GraftTheme.teal)
                        .clipShape(Capsule())
                }
            }

            if workspace.pendingChangeSets.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "checkmark.seal")
                        .font(.title2)
                        .foregroundStyle(GraftTheme.teal)
                    Text("No pending edits")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(GraftTheme.ink)
                    Text("External file changes will appear here for review before they replace your draft.")
                        .font(.caption)
                        .foregroundStyle(GraftTheme.muted)
                }
                .graftCard()
            } else {
                ForEach(workspace.pendingChangeSets) { changeSet in
                    Button {
                        workspace.focus(changeSet)
                    } label: {
                        ReviewRailRow(
                            changeSet: changeSet,
                            isSelected: changeSet.id == workspace.selectedChangeSetID
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
        }
        .padding(16)
        .frame(minWidth: 280, idealWidth: 320, maxWidth: 360)
        .background(GraftTheme.surfaceSoft)
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(GraftTheme.line)
                .frame(width: 1)
        }
    }

    private var fileContext: String {
        if let selectedFile = workspace.selectedFile {
            "Reviewing \(selectedFile.relativePath)"
        } else if let workspaceURL = workspace.workspaceURL {
            workspaceURL.lastPathComponent
        } else {
            "No workspace open"
        }
    }
}

private struct ReviewRailRow: View {
    let changeSet: ChangeSet
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: changeSet.status == .conflict ? "exclamationmark.triangle.fill" : "doc.text.magnifyingglass")
                    .foregroundStyle(changeSet.status == .conflict ? GraftTheme.pink : GraftTheme.teal)
                Text(changeSet.summary)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(GraftTheme.ink)
                    .lineLimit(2)
            }

            HStack(spacing: 6) {
                Image(systemName: "doc.plaintext")
                    .font(.caption2)
                Text(changeSet.filePath)
                    .lineLimit(1)
            }
            .font(.caption)
            .foregroundStyle(GraftTheme.muted)

            HStack(spacing: 8) {
                Text(changeSet.authorName)
                    .lineLimit(1)
                Spacer()
                Text(hunkCountLabel)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(GraftTheme.teal)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(GraftTheme.mint.opacity(0.24))
                    .clipShape(Capsule())
                if changeSet.hasConflicts {
                    Text("Conflict")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(GraftTheme.pink)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(GraftTheme.pink.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
            .font(.caption2)
            .foregroundStyle(GraftTheme.muted)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? GraftTheme.lavender.opacity(0.28) : GraftTheme.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(isSelected ? GraftTheme.teal.opacity(0.35) : GraftTheme.line, lineWidth: 1)
        }
    }

    private var hunkCountLabel: String {
        "\(changeSet.ranges.count) \(changeSet.ranges.count == 1 ? "hunk" : "hunks")"
    }
}
