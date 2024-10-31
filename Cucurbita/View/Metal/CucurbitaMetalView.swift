//
//  CucurbitaMetalView.swift
//  Cucurbita
//
//  Created by Soulghost on 2024/10/31.
//

import Cocoa
import MetalKit
import SwiftUI

class _CucurbitaMetalView: NSView {
    var dummyMTKView: MTKView!
    var metalLayer = CAMetalLayer()
    var device: MTLDevice!
    var renderer = CucurbitaMetalRenderer()
    var hasSetup = false

    public var brightness: Float {
        get {
            renderer.brightness
        }
        set {
            renderer.brightness = newValue
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    public func onUpdate(_ callback: @escaping CucurbitaMetalRendererUpdateCallback) {
        renderer.onUpdate = callback
    }

    func commonInit() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Failed to create Metal device")
        }
        self.device = device

        wantsLayer = true
        metalLayer.device = device
        metalLayer.framebufferOnly = true
        metalLayer.isOpaque = false
        metalLayer.wantsExtendedDynamicRangeContent = true
        metalLayer.pixelFormat = .rgba16Float
        layer?.addSublayer(metalLayer)

        dummyMTKView = MTKView()
        addSubview(dummyMTKView)
        dummyMTKView.delegate = renderer
        renderer.targetLayer = metalLayer
    }

    override func layout() {
        super.layout()
        guard frame.width > 0, frame.height > 0 else { return }
        metalLayer.frame = frame
        setupRendererIfNeeded()
    }

    private func setupRendererIfNeeded() {
        if hasSetup { return }
        hasSetup = true
        renderer.setup(device, size: metalLayer.frame.size)
    }
}

struct CucurbitaMetalView: NSViewRepresentable {
    typealias UIViewType = _CucurbitaMetalView

    var brightness: Double

    func makeNSView(context _: Context) -> some NSView {
        let view = _CucurbitaMetalView()
        view.brightness = Float(brightness)
        return view
    }

    func updateNSView(_ nsView: NSViewType, context _: Context) {
        guard let view = nsView as? _CucurbitaMetalView else {
            return
        }
        view.brightness = Float(brightness)
    }
}
