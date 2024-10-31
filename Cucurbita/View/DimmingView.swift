//
//  DimmingView.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import SwiftUI

struct DimmingView: View {
    @State var bornAnimation: Double = 0
    @StateObject var vm = ViewModel.shared

    var animation: Animation {
        .interpolatingSpring(stiffness: 32, damping: 32)
    }

    let maxOpacity: Double = 0.9

    var decisionOpacity: Double {
        if !vm.tutorialCompleted { return 0.75 }
        return maxOpacity - vm.life * maxOpacity
    }

    var body: some View {
        ZStack {
            Rectangle()
                .opacity(bornAnimation)
                .foregroundStyle(.black.opacity(decisionOpacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        bornAnimation = 1
                    }
                }
        }
        .animation(animation, value: bornAnimation)
        .animation(animation, value: vm.life)
    }
}
