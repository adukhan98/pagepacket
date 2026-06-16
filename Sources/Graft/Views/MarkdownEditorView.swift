import SwiftUI

struct MarkdownEditorView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(workspace.selectedFile?.title ?? "Untitled")
                        .font(.title2.weight(.semibold))
                    Text(workspace.selectedFile?.relativePath ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    workspace.insertImageFromPanel()
                } label: {
                    Label("Image", systemImage: "photo.badge.plus")
                }
                Button {
                    workspace.saveCurrentDocument()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(GraftTheme.surfaceSoft)

            TextEditor(text: $workspace.editorText)
                .font(.system(size: workspace.editorFontSize, design: .monospaced))
                .scrollContentBackground(.hidden)
                .padding(18)
                .background(GraftTheme.canvas)
        }
    }
}
