import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
struct GraftApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var workspace = WorkspaceStore()

    var body: some Scene {
        WindowGroup("Graft") {
            ContentView()
                .environmentObject(workspace)
                .frame(minWidth: 1120, minHeight: 720)
                .onAppear {
                    workspace.bootstrap()
                }
        }
        .commands {
            GraftCommands(workspace: workspace)
        }

        Settings {
            SettingsView()
                .environmentObject(workspace)
                .frame(width: 520)
                .padding(24)
        }
    }
}
