import SwiftUI

struct PagepacketCommands: Commands {
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
                workspace.snapshotCurrentDocument(reason: "Manual checkpoint", source: "Pagepacket")
            }
            .keyboardShortcut("s", modifiers: [.command, .shift])
        }

        CommandMenu("View") {
            Picker("Editor Mode", selection: Binding(
                get: { workspace.editorMode },
                set: { workspace.editorMode = $0 }
            )) {
                ForEach(EditorMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.inline)

            Button("Toggle Inspector") {
                workspace.isInspectorVisible.toggle()
            }
            .keyboardShortcut("i", modifiers: [.command, .option])
        }
    }
}
