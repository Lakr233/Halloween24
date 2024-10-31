//
//  AppDelegate.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var windowController: NSWindowController? = nil
    var dimmingController: NSWindowController? = nil

    func applicationDidFinishLaunching(_: Notification) {
        prepareApplicationMenu()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resetWindows),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(activateWindowIfNeeded),
            name: .hoverCucurbita,
            object: nil
        )

        resetWindows()
    }

    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows _: Bool) -> Bool {
        false
    }

    func applicationShouldTerminate(_: NSApplication) -> NSApplication.TerminateReply {
        .terminateNow
    }

    @objc func resetWindows() {
        windowController?.close()
        windowController = nil

        dimmingController?.close()
        dimmingController = nil

        guard let mainScreen = NSScreen.main else { return }
        let newWindowController = TopmostWindowController(screen: mainScreen)
        newWindowController.window?.contentViewController = HostingController(ContentView())
        newWindowController.window?.setFrame(mainScreen.frame, display: true)
        windowController = newWindowController

        let newDimmingController = NoneInteractWindowController(screen: mainScreen)
        newDimmingController.window?.contentViewController = DimmingController(DimmingView())
        newDimmingController.window?.setFrame(mainScreen.frame, display: true)
        dimmingController = newDimmingController

        activateWindowIfNeeded()
    }

    @objc func activateWindowIfNeeded() {
        let controllers = [
            dimmingController,
            windowController,
        ].compactMap { $0 }

        for controller in controllers {
            controller.window?.orderFrontRegardless()
            if controller.window?.canBecomeKey ?? false,
               controller.window?.canBecomeMain ?? false
            { controller.window?.makeKeyAndOrderFront(nil) }
            controller.showWindow(nil)
        }

        NSApp.activate(ignoringOtherApps: true)
    }
}
