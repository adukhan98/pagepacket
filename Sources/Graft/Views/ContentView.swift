import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .navigationSplitViewColumnWidth(min: 220, ideal: 280)
        } detail: {
            VStack(spacing: 0) {
                ExternalChangeBanner()
                EditorContainerView()
                StatusStrip()
            }
            .background(GraftTheme.canvas)
        }
        .inspector(isPresented: $workspace.isInspectorVisible) {
            InspectorView()
                .inspectorColumnWidth(min: 280, ideal: 340, max: 420)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Button {
                    workspace.openWorkspacePanel()
                } label: {
                    Label("Open Workspace", systemImage: "folder")
                }
            }

            ToolbarItemGroup(placement: .principal) {
                Picker("Mode", selection: $workspace.editorMode) {
                    ForEach(EditorMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 220)
            }

            ToolbarItemGroup {
                Button {
                    workspace.saveCurrentDocument()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }

                Button {
                    workspace.snapshotCurrentDocument(reason: "Manual checkpoint", source: "Pagepacket")
                } label: {
                    Label("Snapshot", systemImage: "clock.arrow.circlepath")
                }

                Button {
                    workspace.insertImageFromPanel()
                } label: {
                    Label("Insert Image", systemImage: "photo")
                }

                Button {
                    workspace.isInspectorVisible.toggle()
                } label: {
                    Label("Inspector", systemImage: "slider.horizontal.3")
                }
            }
        }
    }
}

private struct ExternalChangeBanner: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        if let banner = workspace.externalChangeBanner {
            HStack(spacing: 12) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundStyle(GraftTheme.teal)
                Text(banner)
                    .font(.callout)
                Spacer()
                Button("Use Disk") {
                    workspace.reloadSelectedFromDisk()
                }
                Button("Keep Mine") {
                    workspace.keepLocalVersion()
                }
                Button {
                    workspace.externalChangeBanner = nil
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(GraftTheme.lavender.opacity(0.28))
        }
    }
}

private struct StatusStrip: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        HStack(spacing: 14) {
            Label(workspace.isDirty ? "Unsaved" : "Saved", systemImage: workspace.isDirty ? "circle.fill" : "checkmark.circle")
                .foregroundStyle(workspace.isDirty ? GraftTheme.pink : GraftTheme.teal)
            Text("\(workspace.editorText.split(whereSeparator: \.isWhitespace).count) words")
            Text(workspace.workspaceURL?.lastPathComponent ?? "No workspace")
            Spacer()
            ForEach(workspace.agents.prefix(3)) { agent in
                HStack(spacing: 5) {
                    Circle()
                        .fill(GraftTheme.accent(agent.accentName))
                        .frame(width: 8, height: 8)
                    Text(agent.name)
                }
            }
            Text(".pagepacket local-first")
                .foregroundStyle(.secondary)
        }
        .font(.caption)
        .padding(.horizontal, 16)
        .frame(height: 30)
        .background(.regularMaterial)
    }
}
