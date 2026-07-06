import AppKit
import GraftCore
import SwiftUI

struct MarkdownEditorView: View {
    @EnvironmentObject private var workspace: WorkspaceStore
    @State private var editorSelection = EditorSelection()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(workspace.selectedFile?.title ?? "Untitled")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(GraftTheme.ink)
                    Text(workspace.selectedFile?.relativePath ?? "")
                        .font(.caption)
                        .foregroundStyle(GraftTheme.muted)
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

            if let changeSet = selectedChangeSet {
                ScrollView(.vertical) {
                    InlineDiffView(
                        changeSet: changeSet,
                        onAccept: { workspace.accept(changeSet) },
                        onReject: { workspace.reject(changeSet) }
                    )
                    .padding(16)
                }
                .frame(maxHeight: 280)
                .background(GraftTheme.surfaceSoft)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(GraftTheme.line)
                        .frame(height: 1)
                }
            }

            MarkdownTextView(
                text: Binding(
                    get: { workspace.editorText },
                    set: { newText in
                        workspace.editorText = newText
                        workspace.autosaveCurrentDocumentIfNeeded()
                    }
                ),
                selection: $editorSelection,
                font: .monospacedSystemFont(ofSize: workspace.editorFontSize, weight: .regular),
                isEditable: workspace.selectedFile != nil
            )
            .background(GraftTheme.canvas)
        }
    }

    private var selectedChangeSet: ChangeSet? {
        guard let selectedID = workspace.selectedChangeSetID else { return nil }
        return workspace.pendingChangeSets.first { $0.id == selectedID }
    }
}
