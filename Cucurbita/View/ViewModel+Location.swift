//
//  ViewModel+Location.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import Foundation

extension ViewModel {
    struct CucurbitaLocation: Codable, Equatable {
        var x: Double
        var y: Double

        init(unionX: Double, unionY: Double) {
            x = unionX
            y = unionY
            fixup()
        }

        mutating func fixup() {
            let edgeBoundary = 0.05
            if x < -1 + edgeBoundary { x = -1 + edgeBoundary }
            if x > 1 - edgeBoundary { x = 1 - edgeBoundary }
            if y < -1 + edgeBoundary { y = -1 + edgeBoundary }
            if y > 1 - edgeBoundary { y = 1 - edgeBoundary }
        }
    }
}
