import SwiftUI

struct ShareView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Review Packet", icon: "shippingbox")
            Text("Create a local checkpoint for the current Markdown file before sending the folder, file, or diff context to another reviewer.")
                .font(.callout)
                .foregroundStyle(GraftTheme.body)

            VStack(alignment: .leading, spacing: 10) {
                Text(workspace.selectedFile?.relativePath ?? "No file selected")
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(GraftTheme.ink)
                    .lineLimit(2)

                Text("\(workspace.pendingChangeSets.count) pending agent edits in this workspace")
                    .font(.caption)
                    .foregroundStyle(GraftTheme.muted)

                Button {
                    workspace.createReviewPacket()
                } label: {
                    Label("Create Packet Checkpoint", systemImage: "archivebox")
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .graftCard()

            if workspace.pendingChangeSets.isEmpty {
                Text("No pending edits to include yet.")
                    .font(.callout)
                    .foregroundStyle(GraftTheme.muted)
                    .graftCard()
            } else {
                ForEach(workspace.pendingChangeSets) { changeSet in
                    HStack(spacing: 10) {
                        Image(systemName: changeSet.status == .conflict ? "exclamationmark.triangle" : "doc.text.magnifyingglass")
                            .foregroundStyle(changeSet.status == .conflict ? GraftTheme.pink : GraftTheme.teal)
                            .frame(width: 28, height: 28)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(changeSet.summary)
                                .foregroundStyle(GraftTheme.ink)
                            Text("\(changeSet.authorName) · \(changeSet.filePath)")
                                .font(.caption)
                                .foregroundStyle(GraftTheme.muted)
                        }
                        Spacer()
                        Button {
                            workspace.focus(changeSet)
                        } label: {
                            Label("Show review", systemImage: "arrow.right")
                                .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.plain)
                        .help("Show review")
                        .accessibilityLabel("Show review for \(changeSet.summary)")
                    }
                    .graftCard()
                }
            }
        }
    }
}
