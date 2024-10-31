//
//  DimmingView.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import SwiftUI

struct DimmingView: View {
    @State var opacityControl: Double = 0
    @StateObject var vm = ViewModel.shared

    var animation: Animation {
        .interpolatingSpring(stiffness: 32, damping: 32)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .opacity(opacityControl)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        opacityControl = 1
                    }
                }
                .foregroundStyle(.black.opacity(0.85 - 0.5 * vm.life))
        }
        .animation(animation, value: opacityControl)
        .animation(animation, value: vm.life)
    }
}
