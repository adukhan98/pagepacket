import AppKit
import SwiftUI

@main
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private static var retainedDelegate: AppDelegate?

    private let workspace = WorkspaceStore()
    private var mainWindow: NSWindow?
    private var settingsWindow: NSWindow?
    private var editorModeItems: [NSMenuItem] = []
    private var inspectorMenuItem: NSMenuItem?

    static func main() {
        let app = NSApplication.shared
        app.appearance = NSAppearance(named: .aqua)
        let delegate = AppDelegate()
        retainedDelegate = delegate
        app.delegate = delegate
        app.setActivationPolicy(.regular)
        delegate.configureMainMenu()
        delegate.showMainWindow()
        app.run()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        showMainWindow()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            showMainWindow()
        }
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        false
    }

    func application(_ app: NSApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        false
    }

    func application(_ app: NSApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        false
    }

    func menuNeedsUpdate(_ menu: NSMenu) {
        for item in editorModeItems {
            guard let rawValue = item.representedObject as? String,
                  let mode = EditorMode(rawValue: rawValue) else { continue }
            item.state = workspace.editorMode == mode ? .on : .off
        }
        inspectorMenuItem?.state = workspace.isInspectorVisible ? .on : .off
    }

    private func showMainWindow() {
        if mainWindow == nil {
            let rootView = ContentView()
                .environmentObject(workspace)
                .frame(minWidth: 1120, minHeight: 720)
                .preferredColorScheme(.light)
                .tint(GraftTheme.teal)
                .onAppear {
                    self.workspace.bootstrap()
                }

            let window = NSWindow(
                contentRect: defaultDocumentFrame(),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            window.title = "Pagepacket"
            window.minSize = NSSize(width: 1120, height: 720)
            window.isReleasedWhenClosed = false
            window.contentViewController = NSHostingController(rootView: rootView)
            mainWindow = window
        }

        guard let mainWindow else { return }
        if mainWindow.frame.width < 400 || mainWindow.frame.height < 400 {
            mainWindow.setFrame(defaultDocumentFrame(), display: true)
        }
        NSApp.activate(ignoringOtherApps: true)
        mainWindow.makeKeyAndOrderFront(nil)
    }

    private func showSettingsWindow() {
        if settingsWindow == nil {
            let rootView = SettingsView()
                .environmentObject(workspace)
                .frame(width: 520)
                .padding(24)
                .preferredColorScheme(.light)
                .tint(GraftTheme.teal)

            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 568, height: 360),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            window.title = "Settings"
            window.isReleasedWhenClosed = false
            window.contentViewController = NSHostingController(rootView: rootView)
            window.center()
            settingsWindow = window
        }

        NSApp.activate(ignoringOtherApps: true)
        settingsWindow?.makeKeyAndOrderFront(nil)
    }

    private func defaultDocumentFrame() -> NSRect {
        let visibleFrame = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        let width = min(1360, max(1120, visibleFrame.width - 80))
        let height = min(772, max(560, visibleFrame.height - 80))
        return NSRect(
            x: visibleFrame.midX - width / 2,
            y: visibleFrame.midY - height / 2,
            width: width,
            height: height
        )
    }

    private func configureMainMenu() {
        let mainMenu = NSMenu()
        mainMenu.addItem(appMenuItem())
        mainMenu.addItem(fileMenuItem())
        mainMenu.addItem(editMenuItem())
        mainMenu.addItem(viewMenuItem())
        NSApp.mainMenu = mainMenu
    }

    private func appMenuItem() -> NSMenuItem {
        let menuItem = NSMenuItem()
        let menu = NSMenu()
        menu.addItem(withTitle: "About Pagepacket", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        menu.addItem(.separator())

        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(showSettingsAction(_:)), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit Pagepacket", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menuItem.submenu = menu
        return menuItem
    }

    private func fileMenuItem() -> NSMenuItem {
        let menuItem = NSMenuItem()
        let menu = NSMenu(title: "File")

        let openItem = NSMenuItem(title: "Open Workspace...", action: #selector(openWorkspaceAction(_:)), keyEquivalent: "O")
        openItem.keyEquivalentModifierMask = [.command, .shift]
        openItem.target = self
        menu.addItem(openItem)

        let saveItem = NSMenuItem(title: "Save Document", action: #selector(saveDocumentAction(_:)), keyEquivalent: "s")
        saveItem.keyEquivalentModifierMask = .command
        saveItem.target = self
        menu.addItem(saveItem)

        let snapshotItem = NSMenuItem(title: "Snapshot Version", action: #selector(snapshotAction(_:)), keyEquivalent: "S")
        snapshotItem.keyEquivalentModifierMask = [.command, .shift]
        snapshotItem.target = self
        menu.addItem(snapshotItem)

        menuItem.submenu = menu
        return menuItem
    }

    private func editMenuItem() -> NSMenuItem {
        let menuItem = NSMenuItem()
        let menu = NSMenu(title: "Edit")
        menu.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
        menu.addItem(withTitle: "Redo", action: Selector(("redo:")), keyEquivalent: "Z")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        menu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        menu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        menu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        menuItem.submenu = menu
        return menuItem
    }

    private func viewMenuItem() -> NSMenuItem {
        let menuItem = NSMenuItem()
        let menu = NSMenu(title: "View")
        menu.delegate = self

        for mode in EditorMode.allCases {
            let item = NSMenuItem(title: mode.title, action: #selector(editorModeAction(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = mode.rawValue
            editorModeItems.append(item)
            menu.addItem(item)
        }

        menu.addItem(.separator())

        let inspectorItem = NSMenuItem(title: "Toggle Inspector", action: #selector(toggleInspectorAction(_:)), keyEquivalent: "i")
        inspectorItem.keyEquivalentModifierMask = [.command, .option]
        inspectorItem.target = self
        inspectorMenuItem = inspectorItem
        menu.addItem(inspectorItem)

        menuItem.submenu = menu
        return menuItem
    }

    @objc private func showSettingsAction(_ sender: Any?) {
        showSettingsWindow()
    }

    @objc private func openWorkspaceAction(_ sender: Any?) {
        workspace.openWorkspacePanel()
    }

    @objc private func saveDocumentAction(_ sender: Any?) {
        workspace.saveCurrentDocument()
    }

    @objc private func snapshotAction(_ sender: Any?) {
        workspace.snapshotCurrentDocument(reason: "Manual checkpoint", source: "Pagepacket")
    }

    @objc private func editorModeAction(_ sender: NSMenuItem) {
        guard let rawValue = sender.representedObject as? String,
              let mode = EditorMode(rawValue: rawValue) else { return }
        workspace.setEditorMode(mode)
    }

    @objc private func toggleInspectorAction(_ sender: Any?) {
        workspace.toggleInspector()
    }
}
