import SwiftUI

struct SidebarView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Graft")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundStyle(GraftTheme.ink)
                Text("Local-first Markdown for humans and agents")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)

            List(selection: Binding(
                get: { workspace.selectedFile },
                set: { file in
                    if let file {
                        workspace.load(file: file)
                    }
                }
            )) {
                Section("Markdown") {
                    ForEach(workspace.files) { file in
                        HStack(spacing: 8) {
                            Image(systemName: "doc.text")
                                .foregroundStyle(GraftTheme.teal)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(file.title)
                                    .lineLimit(1)
                                Text(file.relativePath)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        .tag(file)
                    }
                }

                Section("Agents") {
                    ForEach(workspace.agents) { agent in
                        HStack(spacing: 8) {
                            Circle()
                                .strokeBorder(GraftTheme.accent(agent.accentName), lineWidth: 2)
                                .background(Circle().fill(GraftTheme.accent(agent.accentName).opacity(0.16)))
                                .frame(width: 18, height: 18)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(agent.name)
                                Text(agent.status)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        }
        .background(.thinMaterial)
    }
}
