//
//  ViewModel.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import Foundation

class ViewModel: ObservableObject {
    static let shared = ViewModel()

    private init() {
        cucurbitaUnionLocation.fixup()

        let timer = Timer(timeInterval: 0.25, repeats: true) { [weak self] _ in
            guard self?.tutorialCompleted ?? false else { return }
            self?.tik()
        }
        RunLoop.main.add(timer, forMode: .common)
    }

    @PublishedPersist(key: "TutorialCompleted", defaultValue: false)
    var tutorialCompleted: Bool

    let tutorialList: [String] = [
        NSLocalizedString("This is your Cucurbita, it will shine for you.", comment: ""),
        NSLocalizedString("But the light will fade away over time.", comment: ""),
        NSLocalizedString("Click to light it up!", comment: ""),
        NSLocalizedString("If you did't light it up in a while, it will dive.", comment: ""),
        NSLocalizedString("Click to save it!", comment: ""),
        NSLocalizedString("... and it will shine again.", comment: ""),
        NSLocalizedString("Enjoy your Halloween!", comment: ""),
        NSLocalizedString("...", comment: ""),
        NSLocalizedString("Btw, you can drag it around.", comment: ""),
        NSLocalizedString("...", comment: ""),
        NSLocalizedString("That's all, have fun!", comment: ""),
    ]

    @Published var tutorialIndex: Int = 0

    @PublishedPersist(key: "CucurbitaLocation", defaultValue: .init(unionX: 0, unionY: 0))
    var cucurbitaUnionLocation: CucurbitaLocation

    let cucurbitaSize: Double = 150
    let cucurbitaLightCount: Int = 16
    let cucurbitaLightExtendingBoundary: Double = 16

    @Published var life: Double = 1

    @Published var dynamicRangeMultiplier: Double = 1

    func tik() {
        guard life > 0.05 else { return }
        life *= 0.995
    }

    func tok() {
        var newValue: Double = life + 0.1
        if newValue > 1 { newValue = 1 }
        life = newValue
    }

    func nextTip() {
        if tutorialIndex < tutorialList.count - 1 {
            tutorialIndex += 1
        } else {
            tutorialCompleted = true
            tutorialIndex = 0
            life = 0.8
        }
    }
}
