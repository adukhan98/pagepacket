import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        Form {
            Section("Editor") {
                Toggle("Autosave edits to disk", isOn: $workspace.autosaveEnabled)
                Stepper("Editor font size: \(Int(workspace.editorFontSize)) pt", value: $workspace.editorFontSize, in: 12...24)
                Toggle("Show external agent changes", isOn: $workspace.externalChangeDetectionEnabled)
            }

            Section("Workspace") {
                LabeledContent("Sidecar folder", value: ".pagepacket")
                LabeledContent("Asset folder", value: "assets")
            }
        }
    }
}
