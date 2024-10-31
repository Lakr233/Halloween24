//
//  HostingController.swift
//  Halloween24
//
//  Created by 秋星桥 on 2024/10/31.
//

import AppKit
import SwiftUI

class HostingController: NSHostingController<AnyView> {
    init(_ view: AnyView) {
        super.init(rootView: view)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    convenience init(_ view: some View) {
        self.init(AnyView(view))
    }
}
