import SwiftUI

struct EditorContainerView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        Group {
            if workspace.selectedFile == nil {
                EmptyWorkspaceView()
            } else {
                switch workspace.editorMode {
                case .edit:
                    MarkdownEditorView()
                case .preview:
                    MarkdownPreviewView()
                case .split:
                    HSplitView {
                        MarkdownEditorView()
                            .frame(minWidth: 360)
                        MarkdownPreviewView()
                            .frame(minWidth: 360)
                    }
                }
            }
        }
    }
}

private struct EmptyWorkspaceView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(GraftTheme.peach)
                    .frame(width: 168, height: 128)
                    .rotationEffect(.degrees(-4))
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(GraftTheme.lavender)
                    .frame(width: 142, height: 104)
                    .rotationEffect(.degrees(6))
                Image(systemName: "doc.richtext")
                    .font(.system(size: 46, weight: .medium))
                    .foregroundStyle(GraftTheme.ink)
            }
            Text("Open a Markdown workspace")
                .font(.system(size: 36, weight: .medium, design: .rounded))
            Text("Graft keeps your Markdown as plain files so people, Codex, Claude Code, Cursor, Hermes, and shell tools can edit the same workspace.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 620)
            Button {
                workspace.openWorkspacePanel()
            } label: {
                Label("Open Workspace", systemImage: "folder")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(48)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GraftTheme.canvas)
    }
}
