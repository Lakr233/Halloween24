//
//  Ext+Window.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import AppKit

extension NSScreen {
    var isBuildinDisplay: Bool {
        let screenNumberKey = NSDeviceDescriptionKey(rawValue: "NSScreenNumber")
        guard let id = deviceDescription[screenNumberKey],
              let rid = (id as? NSNumber)?.uint32Value,
              CGDisplayIsBuiltin(rid) == 1
        else { return false }
        return true
    }

    static var buildin: NSScreen? {
        screens.first { $0.isBuildinDisplay }
    }
}
