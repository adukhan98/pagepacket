import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        placeWindowsOnVisibleScreen()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        placeWindowsOnVisibleScreen()
    }

    private func placeWindowsOnVisibleScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for window in NSApp.windows where window.isVisible {
                guard let screen = window.screen ?? NSScreen.main else { continue }
                let visibleFrame = screen.visibleFrame
                let frame = window.frame
                guard frame.minX < visibleFrame.minX
                    || frame.maxX > visibleFrame.maxX
                    || frame.minY < visibleFrame.minY
                    || frame.maxY > visibleFrame.maxY else {
                    continue
                }

                let newX = visibleFrame.midX - frame.width / 2
                let newY = visibleFrame.midY - frame.height / 2
                window.setFrameOrigin(NSPoint(x: max(visibleFrame.minX, newX), y: max(visibleFrame.minY, newY)))
            }
        }
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
                .frame(minWidth: 1120, minHeight: 720)
                .preferredColorScheme(.light)
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
                .preferredColorScheme(.light)
        }
    }
}
