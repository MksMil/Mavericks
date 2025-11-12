import SwiftUI

@main
struct MavericksApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
        
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.disableRelaunchOnLogin()
        NSApp.windows.forEach { $0.isRestorable = false }
        setupWindow()
    }
    
    // ← ОТКЛЮЧАЕМ ВОССТАНОВЛЕНИЕ
    func applicationShouldRestoreSecureState(_ app: NSApplication) -> Bool {
        return false
    }
    
    func applicationShouldRestoreWindowState(_ app: NSApplication) -> Bool {
        return false
    }
    
    private func setupWindow() {
        window = NSWindow(
            contentRect: CGRect(x: 0, y: 0, width: 1000, height: 1000),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        window.minSize = CGSize(width: 1000, height: 1000)
        window.maxSize = CGSize(width: 1000, height: 1000)
        
        // ← ОТКЛЮЧАЕМ ВОССТАНОВЛЕНИЕ ДЛЯ ЭТОГО ОКНА
        window.isRestorable = false
        window.identifier = NSUserInterfaceItemIdentifier("GameWindow")
        
        window.contentView = NSHostingView(rootView: StartView())
        window.center()
        window.makeKeyAndOrderFront(nil)
    }
}


