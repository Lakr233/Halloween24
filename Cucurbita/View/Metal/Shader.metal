//
//  Shader.metal
//  Cucurbita
//
//  Created by Soulghost on 2024/10/31.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
    float2 uv;
};

struct RasterizerData
{
    float4 position [[position]];
    float2 uv;
    float brightness;
};

// Vertex Function
vertex RasterizerData
vert(uint vertexID [[ vertex_id ]],
     constant Vertex *vertexArray [[ buffer(0) ]],
     constant float *brightness [[ buffer(1) ]]) {
    
    RasterizerData out;
    float4 pixelSpacePosition = vertexArray[vertexID].position;
    out.position = pixelSpacePosition;
    out.uv = vertexArray[vertexID].uv;
    out.brightness = *brightness;
    return out;
}

// Fragment function
fragment float4
frag(RasterizerData in [[stage_in]],
     texture2d<half> colorTexture [[ texture(0) ]]) {
    
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    const half4 colorSample = colorTexture.sample(textureSampler, in.uv);
    return float4(colorSample) * in.brightness;
}
