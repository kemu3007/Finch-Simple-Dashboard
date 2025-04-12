//
//  Finch_DesktopApp.swift
//  Finch-Desktop
//
//  Created by 市川憲伸 on 2025/04/11.
//

import SwiftUI

@main
struct Finch_DesktopApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // カスタムメニュー設定
        let mainMenu = NSMenu()
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)

        let appMenu = NSMenu()
        let preferencesItem = NSMenuItem(
            title: "Settings…",
            action: #selector(openPreferences),
            keyEquivalent: ","
        )
        preferencesItem.target = self
        appMenu.addItem(preferencesItem)
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Quit Finch Simple Dashboard",
                        action: #selector(NSApplication.terminate(_:)),
                        keyEquivalent: "q")
        appMenuItem.submenu = appMenu
        NSApplication.shared.mainMenu = mainMenu
    }

    @objc func openPreferences() {
        let window = NSWindow(
            contentRect: NSRect(x: 200, y: 300, width: 1000, height: 600),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Settings..."
        window.contentView = NSHostingView(rootView: ConfigView())
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
    }
}
