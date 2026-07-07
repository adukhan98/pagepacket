import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.appearance = NSAppearance(named: .aqua)
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
struct PagepacketApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var workspace = WorkspaceStore()

    var body: some Scene {
        WindowGroup("Pagepacket") {
            ContentView()
                .environmentObject(workspace)
                .preferredColorScheme(.light)
                .tint(PagepacketTheme.teal)
                .frame(minWidth: 1120, minHeight: 720)
                .onAppear {
                    workspace.bootstrap()
                }
        }
        .commands {
            PagepacketCommands(workspace: workspace)
        }

        Settings {
            SettingsView()
                .environmentObject(workspace)
                .preferredColorScheme(.light)
                .tint(PagepacketTheme.teal)
                .frame(width: 520)
                .padding(24)
        }
    }
}
