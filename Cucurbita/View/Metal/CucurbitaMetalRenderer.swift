//
//  CucurbitaMetalRenderer.swift
//  Cucurbita
//
//  Created by Soulghost on 2024/10/31.
//

import Cocoa
import Metal
import MetalKit

typealias CucurbitaMetalRendererUpdateCallback = (Float) -> Void

class CucurbitaMetalRenderer: NSObject {
    var device: MTLDevice!
    var targetLayer: CAMetalLayer?
    var isPrepared = false
    var renderPipeline: MTLRenderPipelineState!
    var computePipeline: MTLComputePipelineState!
    var vertexBuffer: MTLBuffer!
    var targetFrameSize: simd_float2!
    var commandQueue: MTLCommandQueue!
    var cucurbitaTexture: MTLTexture!
    var lastTime: CFTimeInterval = -1.0
    
    public var brightness: Float = 1.0
    public var onUpdate: CucurbitaMetalRendererUpdateCallback?
    
    private struct Vertex {
        var position: simd_float4
        var uv: simd_float2
    }

    func setup(_ device: MTLDevice, size: CGSize) {
        self.device = device
        makeRenderPipeline(device, size: size)
    }
    
    func makeRenderPipeline(_ device: MTLDevice, size: CGSize) {
        guard !isPrepared else {
            return
        }

        guard let library = device.makeDefaultLibrary() else {
            fatalError("Failed to initialize Metal library")
        }

        let vertexFunction = library.makeFunction(name: "vert")!
        let fragmentFunction = library.makeFunction(name: "frag")!

        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .rgba16Float
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        renderPipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        renderPipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
        renderPipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        renderPipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        renderPipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        renderPipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipeline = try! device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)

        let vertices: [Vertex] = [
            .init(position: .init(1, -1, 0, 1), uv: .init(1, 1)),
            .init(position: .init(-1, -1, 0, 1), uv: .init(0, 1)),
            .init(position: .init(-1, 1, 0, 1), uv: .init(0, 0)),
            
            .init(position: .init(1, -1, 0, 1), uv: .init(1, 1)),
            .init(position: .init(-1, 1, 0, 1), uv: .init(0, 0)),
            .init(position: .init(1, 1, 0, 1), uv: .init(1, 0)),
        ]
        let vertexBuffer = vertices.withUnsafeBytes { pointer in
            device.makeBuffer(bytes: pointer.baseAddress!,
                              length: MemoryLayout<Vertex>.stride * vertices.count,
                              options: .storageModeManaged)
        }
        self.vertexBuffer = vertexBuffer!
        targetFrameSize = .init(Float(size.width), Float(size.height))
        commandQueue = device.makeCommandQueue()!

        let textureLoader = MTKTextureLoader(device: device)
        
        guard let image = NSImage(named: "JackLantern") else {
            return
        }
        if let cgImage = image.cgImage {
            cucurbitaTexture = try! textureLoader.newTexture(cgImage: cgImage)
        }

        isPrepared = true
    }
    
    func resize(_ size: CGSize) {
        targetFrameSize = .init(Float(size.width), Float(size.height))
    }
}

extension CucurbitaMetalRenderer: MTKViewDelegate {
    func draw(in view: MTKView) {
        guard isPrepared else { return }

        guard let drawable = targetLayer?.nextDrawable() else { return }
        if lastTime < 0 {
            lastTime = CACurrentMediaTime()
            return
        }

        let currentTime = CACurrentMediaTime()
        let deltaTime = simd_float1(currentTime - lastTime)
        lastTime = currentTime
        if let update = onUpdate {
            update(deltaTime)
        }

        let renderCommandBuffer = commandQueue.makeCommandBuffer()!

        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store

        let renderCommandEncoder = renderCommandBuffer.makeRenderCommandEncoder(
            descriptor: renderPassDescriptor
        )!
        renderCommandEncoder.setRenderPipelineState(renderPipeline)
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setVertexBytes(&brightness, length: 4, index: 1)
        renderCommandEncoder.setFragmentTexture(cucurbitaTexture, index: 0)
        renderCommandEncoder.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: 6
        )
        renderCommandEncoder.endEncoding()

        renderCommandBuffer.present(drawable)
        renderCommandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}

extension NSImage {
    var cgImage: CGImage? {
        guard let imageData = self.tiffRepresentation else { return nil }
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(source, 0, nil)
    }
}
