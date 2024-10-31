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
            self?.tik()
        }
        RunLoop.main.add(timer, forMode: .common)
    }

    @PublishedPersist(key: "CucurbitaLocation", defaultValue: .init(unionX: 0, unionY: 0))
    var cucurbitaUnionLocation: CucurbitaLocation

    let cucurbitaSize: Double = 150
    let cucurbitaLightCount: Int = 16
    let cucurbitaLightExtendingBoundary: Double = 16

    @Published var life: Double = 1

    func tik() {
        guard life > 0.05 else { return }
        life *= 0.995
    }

    func tok() {
        var newValue: Double = life + 0.1
        if newValue > 1 { newValue = 1 }
        life = newValue
    }
}
