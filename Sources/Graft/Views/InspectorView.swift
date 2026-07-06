import SwiftUI

struct InspectorView: View {
    @EnvironmentObject private var workspace: WorkspaceStore
    @State private var selectedTab = "History"
    private let tabs = ["History", "Share", "Agents"]

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Inspector")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(GraftTheme.body)
                GraftSegmentedControl(
                    items: tabs.map { ($0, $0) },
                    selection: $selectedTab
                )
            }
            .padding(14)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    switch selectedTab {
                    case "Share":
                        ShareView()
                    case "Agents":
                        AgentsPanel()
                    default:
                        HistoryView()
                    }
                }
                .padding(16)
            }
        }
        .background(GraftTheme.surfaceSoft)
        .foregroundStyle(GraftTheme.body)
    }
}

private struct AgentsPanel: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Agent-Safe Editing", icon: "wand.and.sparkles")
            Text("Pagepacket keeps Markdown files writable by coding agents. External changes are converted into local review packets before they replace your draft.")
                .font(.callout)
                .foregroundStyle(GraftTheme.body)

            if workspace.agents.isEmpty {
                Text("No external edits detected in this session.")
                    .font(.callout)
                    .foregroundStyle(GraftTheme.muted)
                    .graftCard()
            } else {
                ForEach(workspace.agents) { agent in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Circle()
                                .fill(GraftTheme.accent(agent.accentName))
                                .frame(width: 10, height: 10)
                            Text(agent.name)
                                .font(.headline)
                                .foregroundStyle(GraftTheme.ink)
                            Spacer()
                            Text(agent.status)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(GraftTheme.ink)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(GraftTheme.accent(agent.accentName).opacity(0.18))
                                .clipShape(Capsule())
                        }
                        Text(agent.detail)
                            .font(.caption)
                            .foregroundStyle(GraftTheme.body)
                    }
                    .graftCard()
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Agent workflow")
                    .font(.headline)
                    .foregroundStyle(GraftTheme.ink)
                CommandLineRow(label: "Status", command: "pagepacket-cli status <vault>")
                CommandLineRow(label: "Checkpoint", command: "pagepacket-cli snapshot <vault> <file> --message \"Before edits\"")
                CommandLineRow(label: "Submit", command: "pagepacket-cli submit-change <vault> <file> --agent codex --summary \"Edited draft\"")
            }
            .graftCard()
        }
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(GraftTheme.teal)
            Text(title)
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(GraftTheme.ink)
            Spacer()
        }
    }
}

struct CommandLineRow: View {
    let label: String
    let command: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(GraftTheme.body)
            ScrollView(.horizontal, showsIndicators: false) {
                Text(command)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(GraftTheme.ink)
                    .textSelection(.enabled)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 7)
            }
            .background(GraftTheme.controlFill)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .stroke(GraftTheme.line, lineWidth: 1)
            }
        }
    }
}
