//
//  ViewModel+EDR.swift
//  Cucurbita
//
//  Created by 秋星桥 on 2024/10/31.
//

import AppKit

extension ViewModel {
    func updateExtendedDynamicRangeValue(_ screen: NSScreen) {
        var read = screen.maximumExtendedDynamicRangeColorComponentValue
        if read > 2 { read = 2 }
        print("[*] extended dynamic range value: \(read)")
        dynamicRangeMultiplier = max(1.0, read * 0.8)
    }
}
