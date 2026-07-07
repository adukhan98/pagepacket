import SwiftUI

struct SidebarView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("pagepacket")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundStyle(PagepacketTheme.ink)
                Text("Local-first Markdown for humans and agents")
                    .font(.caption)
                    .foregroundStyle(PagepacketTheme.muted)
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
                                .foregroundStyle(PagepacketTheme.teal)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(file.title)
                                    .foregroundStyle(PagepacketTheme.ink)
                                    .lineLimit(1)
                                Text(file.relativePath)
                                    .font(.caption2)
                                    .foregroundStyle(PagepacketTheme.muted)
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
                                .strokeBorder(PagepacketTheme.accent(agent.accentName), lineWidth: 2)
                                .background(Circle().fill(PagepacketTheme.accent(agent.accentName).opacity(0.16)))
                                .frame(width: 18, height: 18)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(agent.name)
                                    .foregroundStyle(PagepacketTheme.ink)
                                Text(agent.status)
                                    .font(.caption2)
                                    .foregroundStyle(PagepacketTheme.muted)
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        }
        .foregroundStyle(PagepacketTheme.body)
        .padding(.leading, 20)
        .background(PagepacketTheme.surfaceSoft)
    }
}
