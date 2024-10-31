//
//  LightingSparkleView.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import SwiftUI

struct LightingSparkleView: View {
    let color: Color

    var gradient: Gradient {
        Gradient(colors: [color, .clear])
    }

    var body: some View {
        GeometryReader { r in
            Circle()
                .frame(width: r.size.width, height: r.size.height)
                .foregroundStyle(
                    RadialGradient(
                        gradient: gradient,
                        center: .center,
                        startRadius: (r.size.width * r.size.height) / 2 * 0.1,
                        endRadius: (r.size.width * r.size.height) / 2 * 0.1
                    )
                )
        }
    }
}
