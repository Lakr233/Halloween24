//
//  NoneInteractWindowController.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import AppKit

class NoneInteractWindowController: NSWindowController {
    init(screen: NSScreen) {
        let window = NoneInteractWindow(
            contentRect: screen.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        super.init(window: window)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError() }
}
