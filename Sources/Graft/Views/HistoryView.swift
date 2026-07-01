import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionHeader(title: "Version History", icon: "clock.arrow.circlepath")
                Button {
                    workspace.snapshotCurrentDocument(reason: "Manual checkpoint", source: "Pagepacket")
                } label: {
                    Image(systemName: "plus")
                }
            }

            if workspace.snapshots.isEmpty {
                Text("No snapshots yet. Save or create a checkpoint to start local history.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .graftCard()
            } else {
                ForEach(workspace.snapshots) { snapshot in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Circle()
                                .fill(GraftTheme.ochre)
                                .frame(width: 9, height: 9)
                            Text(snapshot.displayTitle)
                                .font(.headline)
                            Spacer()
                        }
                        Text(snapshot.reason)
                            .font(.callout)
                        Text(snapshot.timestamp.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack {
                            Text("\(snapshot.byteCount) bytes")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button("Restore") {
                                workspace.restore(snapshot)
                            }
                        }
                    }
                    .graftCard()
                }
            }
        }
    }
}
