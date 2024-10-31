//
//  CucurbitaLightingView.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import SwiftUI

struct CucurbitaLightingView: View {
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()

    @State var randomization: [PointRandomization]

    let colors: [Color] = [
        .sparkleColorA,
        .sparkleColorB,
        .sparkleColorC,
    ]

    init(count: Int) {
        _randomization = State(initialValue: (0 ..< count).map { _ in
            PointRandomization()
        })
    }

    var body: some View {
        GeometryReader { r in
            ZStack {
                ForEach(randomization) { parm in
                    LightingSparkleView(color: colors.randomElement()!)
                        .frame(width: parm.diameter, height: parm.diameter)
                        .offset(x: parm.offsetX, y: parm.offsetY)
                        .opacity(parm.opacity)
                }
                .onAppear { randomize(in: r.size) }
                .onReceive(timer) { _ in randomize(in: r.size) }
            }
            .frame(width: r.size.width, height: r.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.interpolatingSpring(stiffness: 50, damping: 1).speed(0.05), value: randomization)
    }

    func randomize(in size: CGSize) {
        for i in randomization.indices {
            randomization[i].randomizeIn(size: size)
        }
    }
}

extension CucurbitaLightingView {
    struct PointRandomization: Equatable, Hashable, Identifiable {
        var id = UUID()

        var diameter: CGFloat = 0
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        var opacity: CGFloat = 0

        mutating func randomizeIn(size: CGSize) {
            let decision = (size.width + size.height) / 4
            diameter = CGFloat.random(in: (decision * 0.25) ... (decision * 0.75))
            offsetX = CGFloat.random(in: -(size.width / 2) ... +(size.width / 2))
            offsetY = CGFloat.random(in: -(size.height / 2) ... +(size.height / 2))
            opacity = Double.random(in: 0.75 ... 1)
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(diameter)
            hasher.combine(offsetX)
            hasher.combine(offsetY)
            hasher.combine(opacity)
        }

        static func == (lhs: PointRandomization, rhs: PointRandomization) -> Bool {
            [
                lhs.diameter == rhs.diameter,
                lhs.offsetX == rhs.offsetX,
                lhs.offsetY == rhs.offsetY,
                lhs.opacity == rhs.opacity,
            ].allSatisfy { $0 }
        }
    }
}
