import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .navigationSplitViewColumnWidth(min: 280, ideal: 300, max: 340)
        } detail: {
            VStack(spacing: 0) {
                ExternalChangeBanner()
                HStack(spacing: 0) {
                    EditorContainerView()
                    if workspace.editorMode != .split {
                        ReviewRailView()
                    }
                }
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
                GraftSegmentedControl(
                    items: EditorMode.allCases.map { ($0, $0.title) },
                    selection: Binding(
                        get: { workspace.editorMode },
                        set: { workspace.setEditorMode($0) }
                    )
                )
                .frame(width: 220)
            }

            ToolbarItemGroup {
                Button {
                    workspace.saveCurrentDocument()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .help("Save")

                Button {
                    workspace.snapshotCurrentDocument(reason: "Manual checkpoint", source: "Pagepacket")
                } label: {
                    Label("Snapshot", systemImage: "clock.arrow.circlepath")
                }
                .help("Create checkpoint")

                Button {
                    workspace.insertImageFromPanel()
                } label: {
                    Label("Insert Image", systemImage: "photo")
                }
                .help("Insert image")

                Button {
                    workspace.toggleInspector()
                } label: {
                    Label("Inspector", systemImage: "slider.horizontal.3")
                }
                .help("Toggle inspector")
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
                    .foregroundStyle(GraftTheme.ink)
                Spacer()
                if let changeSet = workspace.pendingChangeSets.first(where: { $0.id == workspace.selectedChangeSetID }) {
                    Button("Reject") {
                        workspace.reject(changeSet)
                    }
                    Button("Accept") {
                        workspace.accept(changeSet)
                    }
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
                .foregroundStyle(GraftTheme.body)
            Text(workspace.workspaceURL?.lastPathComponent ?? "No workspace")
                .foregroundStyle(GraftTheme.body)
            Spacer()
            if let activity = workspace.agents.first {
                HStack(spacing: 5) {
                    Circle()
                        .fill(GraftTheme.accent(activity.accentName))
                        .frame(width: 8, height: 8)
                    Text(activity.status)
                        .foregroundStyle(GraftTheme.body)
                }
            } else {
                Text("\(workspace.pendingChangeSets.count) pending reviews")
                    .foregroundStyle(GraftTheme.muted)
            }
            Text(".pagepacket local-first")
                .foregroundStyle(GraftTheme.muted)
        }
        .font(.caption)
        .foregroundStyle(GraftTheme.body)
        .padding(.horizontal, 16)
        .frame(height: 30)
        .background(GraftTheme.surfaceSoft)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(GraftTheme.line)
                .frame(height: 1)
        }
    }
}
