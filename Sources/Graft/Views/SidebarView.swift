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
                    .foregroundStyle(GraftTheme.muted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 64)
            .padding(.trailing, 16)
            .padding(.top, 42)
            .padding(.bottom, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SidebarSectionTitle("Markdown")
                    ForEach(workspace.files) { file in
                        SidebarFileRow(
                            file: file,
                            isSelected: workspace.selectedFile == file
                        ) {
                            workspace.load(file: file)
                        }
                    }

                    if !workspace.agents.isEmpty {
                        SidebarSectionTitle("Activity")
                        ForEach(workspace.agents) { agent in
                            SidebarActivityRow(agent: agent)
                        }
                    }
                }
                .padding(.leading, 56)
                .padding(.trailing, 10)
                .padding(.bottom, 16)
            }
        }
        .graftPanelBackground()
        .frame(minWidth: 280, idealWidth: 300, maxWidth: 340)
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(GraftTheme.line)
                .frame(width: 1)
        }
    }
}

private struct SidebarSectionTitle: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(GraftTheme.ink)
            .textCase(.uppercase)
            .padding(.horizontal, 8)
    }
}

private struct SidebarFileRow: View {
    let file: MarkdownFile
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text")
                    .foregroundStyle(isSelected ? Color.white : GraftTheme.teal)
                    .frame(width: 18)
                VStack(alignment: .leading, spacing: 2) {
                    Text(file.title)
                        .font(.callout.weight(.semibold))
                        .lineLimit(1)
                        .foregroundStyle(isSelected ? Color.white : GraftTheme.ink)
                    Text(file.relativePath)
                        .font(.caption2)
                        .foregroundStyle(isSelected ? Color.white.opacity(0.78) : GraftTheme.muted)
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(isSelected ? GraftTheme.selectedFill : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct SidebarActivityRow: View {
    let agent: AgentActivity

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(GraftTheme.accent(agent.accentName))
                .frame(width: 9, height: 9)
            VStack(alignment: .leading, spacing: 2) {
                Text(agent.name)
                    .foregroundStyle(GraftTheme.ink)
                Text(agent.status)
                    .font(.caption2)
                    .foregroundStyle(GraftTheme.muted)
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(GraftTheme.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
    }
}
