//
//  AppDelegate+Menu.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import AppKit

extension AppDelegate {
    func prepareApplicationMenu() {
        let appMenu = NSMenu()
        appMenu.addItem(
            withTitle: NSLocalizedString("About", comment: ""),
            action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
            keyEquivalent: ""
        )
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(
            withTitle: NSLocalizedString("Quite", comment: ""),
            action: #selector(NSApplication.terminate),
            keyEquivalent: "q"
        )
        if let appMenuItem = NSApp.mainMenu?.items.first {
            appMenuItem.submenu = appMenu
        } else {
            let appMenuItem = NSMenuItem()
            appMenuItem.submenu = appMenu
            NSApp.mainMenu?.addItem(appMenuItem)
        }
    }
}
