//
//  ContentView.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import Pow
import SwiftUI

private let tikInterval: TimeInterval = 2

struct ContentView: View {
    @StateObject var vm = ViewModel.shared

    @State var isDragging: Bool = false
    @State var isHovering: Bool = false
    @State var isTapping: Bool = false
    @State var scaleEffect: CGFloat = 0.5
    @State var opacityEffect: CGFloat = 0
    @State var cucurbitaEmitter: Int = 0

    var animation: Animation {
        .spring()
    }

    var isDead: Bool {
        vm.life < 0.1
    }

    var lifeScale: Double {
        0.5 + 0.5 * vm.life
    }

    let timer = Timer.publish(every: tikInterval, on: .main, in: .common).autoconnect()

    var hintText: String {
        if !vm.tutorialCompleted,
           vm.tutorialIndex >= 0,
           vm.tutorialIndex < vm.tutorialList.count
        {
            return vm.tutorialList[vm.tutorialIndex]
        }
        if vm.life > 0.99 {
            return NSLocalizedString("Happy Halloween!", comment: "")
        } else if vm.life > 0.5 {
            return ""
        } else if isDead {
            return NSLocalizedString("Your Cucurbita is dead! Click to light it up!", comment: "")
        } else {
            return NSLocalizedString("Your Cucurbita is diving! Click NOW to save it!", comment: "")
        }
    }

    var body: some View {
        GeometryReader { r in
            ZStack {
                VStack(alignment: .center, spacing: 8) {
                    Rectangle()
                        .hidden()
                        .frame(width: vm.cucurbitaSize, height: vm.cucurbitaSize)
                        .padding(16)
                    Text(hintText)
                        .bold()
                        .padding(4)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    if !vm.tutorialCompleted {
                        Text("Next Hint")
                            .underline()
                            .bold()
                            .padding(4)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .onTapGesture {
                                vm.nextTip()
                            }
                            .transition(.opacity)
                    }
                }
                .fontDesign(.rounded)
                .contentTransition(.numericText())
                .opacity(hintText.isEmpty ? 0 : 1)
                .animation(animation, value: hintText)
                .animation(animation, value: vm.tutorialIndex)
                .animation(animation, value: vm.tutorialCompleted)
                .offset(
                    x: r.size.width / 2 * CGFloat(vm.cucurbitaUnionLocation.x),
                    y: r.size.height / 2 * CGFloat(vm.cucurbitaUnionLocation.y) + 32
                )

                CucurbitaView()
                    .hidden()
                    .frame(width: vm.cucurbitaSize, height: vm.cucurbitaSize)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let shift = CGPoint(
                                    x: (value.location.x - vm.cucurbitaSize / 2) / (r.size.width / 2),
                                    y: (value.location.y - vm.cucurbitaSize / 2) / (r.size.height / 2)
                                )
                                isDragging = true
                                vm.cucurbitaUnionLocation = .init(
                                    unionX: shift.x,
                                    unionY: shift.y
                                )
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
                    .background(
                        CucurbitaLightingView(count: vm.cucurbitaLightCount)
                            .padding(-vm.cucurbitaLightExtendingBoundary)
                    )
                    .overlay(
                        ZStack {
                            CucurbitaDeadView()
                            CucurbitaMetalView(brightness: vm.dynamicRangeMultiplier * vm.life)
                                .conditionalEffect(
                                    .repeat(
                                        .glow(color: .light, radius: 32),
                                        every: tikInterval
                                    ),
                                    condition: !isDead
                                )
                                .changeEffect(
                                    .spray(origin: .init(x: 0.5, y: 0.5)) { Text("🎃").font(.largeTitle) },
                                    value: cucurbitaEmitter
                                )
                                .onReceive(timer) { _ in
                                    cucurbitaEmitter += 1
                                }
                                .opacity(isDead ? 0 : 0.75 + 0.25 * min(1, vm.life + 0.5))
                        }
                    )
                    .scaleEffect(.init(width: scaleEffect, height: scaleEffect))
                    .scaleEffect(.init(width: lifeScale, height: lifeScale))
                    .scaleEffect(.init(width: isDragging ? 1.1 : 1, height: isDragging ? 1.1 : 1))
                    .scaleEffect(.init(width: isHovering ? 1.1 : 1, height: isHovering ? 1.1 : 1))
                    .scaleEffect(.init(width: isTapping ? 1.1 : 1, height: isTapping ? 1.1 : 1))
                    .opacity(opacityEffect)
                    .offset(
                        x: r.size.width / 2 * CGFloat(vm.cucurbitaUnionLocation.x),
                        y: r.size.height / 2 * CGFloat(vm.cucurbitaUnionLocation.y)
                    )

                Rectangle()
                    .hidden()
                    .frame(width: vm.cucurbitaSize, height: vm.cucurbitaSize)
                    .contentShape(Rectangle())
                    .onHover { hover in
                        isHovering = hover
                        guard hover else { return }
                        NotificationCenter.default.post(name: .hoverCucurbita, object: nil)
                    }
                    .offset(
                        x: r.size.width / 2 * CGFloat(vm.cucurbitaUnionLocation.x),
                        y: r.size.height / 2 * CGFloat(vm.cucurbitaUnionLocation.y)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let shift = CGPoint(
                                    x: (value.location.x - vm.cucurbitaSize / 2) / (r.size.width / 2),
                                    y: (value.location.y - vm.cucurbitaSize / 2) / (r.size.height / 2)
                                )
                                isDragging = true
                                vm.cucurbitaUnionLocation = .init(
                                    unionX: shift.x,
                                    unionY: shift.y
                                )
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
                    .onTapGesture {
                        if !isTapping { isTapping = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isTapping = false
                        }
                        vm.tok()
                    }
            }
            .animation(animation, value: isDragging)
            .animation(animation, value: isHovering)
            .animation(animation, value: isTapping)
            .animation(animation, value: scaleEffect)
            .animation(animation, value: opacityEffect)
            .animation(animation, value: vm.life)
            .animation(animation, value: vm.cucurbitaUnionLocation)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    scaleEffect = 1
                    opacityEffect = 1
                }
            }
            .frame(width: r.size.width, height: r.size.height)
        }
        .environmentObject(vm)
    }
}
