import SwiftUI

struct InspectorView: View {
    @EnvironmentObject private var workspace: WorkspaceStore
    @State private var selectedTab = "History"

    var body: some View {
        VStack(spacing: 0) {
            Picker("Inspector", selection: $selectedTab) {
                Text("History").tag("History")
                Text("Share").tag("Share")
                Text("Agents").tag("Agents")
            }
            .pickerStyle(.segmented)
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
    }
}

private struct AgentsPanel: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Agent-Safe Editing", icon: "wand.and.sparkles")
            Text("Pagepacket keeps Markdown files writable by coding agents. External changes are detected from disk and protected by local snapshots.")
                .font(.callout)
                .foregroundStyle(.secondary)

            ForEach(workspace.agents) { agent in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle()
                            .fill(GraftTheme.accent(agent.accentName))
                            .frame(width: 10, height: 10)
                        Text(agent.name)
                            .font(.headline)
                        Spacer()
                        Text(agent.status)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(GraftTheme.accent(agent.accentName).opacity(0.18))
                            .clipShape(Capsule())
                    }
                    Text(agent.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .graftCard()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("CLI sync contract")
                    .font(.headline)
                MonospaceLine("pagepacket-cli status <vault>")
                MonospaceLine("pagepacket-cli snapshot <vault> <file> --message \"Before edits\"")
                MonospaceLine("pagepacket-cli apply <vault> <file> --author codex")
                MonospaceLine("Use skills/graft-sync/SKILL.md for agent workflow")
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
            Spacer()
        }
    }
}

struct MonospaceLine: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.system(.caption, design: .monospaced))
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(.black.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
