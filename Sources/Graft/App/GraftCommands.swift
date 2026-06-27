import SwiftUI

struct GraftCommands: Commands {
    @ObservedObject var workspace: WorkspaceStore

    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("Open Workspace...") {
                workspace.openWorkspacePanel()
            }
            .keyboardShortcut("o", modifiers: [.command, .shift])

            Button("Save Document") {
                workspace.saveCurrentDocument()
            }
            .keyboardShortcut("s", modifiers: .command)

            Button("Snapshot Version") {
                workspace.snapshotCurrentDocument(reason: "Manual checkpoint", source: "Graft")
            }
            .keyboardShortcut("s", modifiers: [.command, .shift])
        }

        CommandMenu("View") {
            Picker("Editor Mode", selection: Binding(
                get: { workspace.editorMode },
                set: { workspace.setEditorMode($0) }
            )) {
                ForEach(EditorMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.inline)

            Button("Toggle Inspector") {
                workspace.toggleInspector()
            }
            .keyboardShortcut("i", modifiers: [.command, .option])
        }
    }
}
