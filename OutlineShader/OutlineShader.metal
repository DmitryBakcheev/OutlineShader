//
//  OutlineShader.metal
//  OutlineShader
//
//  Created by Dmitry Bakcheev on 11/19/23.
//

#include <metal_stdlib>
using namespace metal;

#include <SceneKit/scn_metal>

struct VertexIn {
    float3 position [[attribute(SCNVertexSemanticPosition)]];
    float3 normal   [[attribute(SCNVertexSemanticNormal)]];
    float2 texcord [[attribute(SCNVertexSemanticTexcoord0)]];
   
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float3 normal;
    float2 texcord;
};

struct MyNodeBuffer {
    float4x4 normalTransform;
    float4x4 modelViewProjectionTransform;
   
};

vertex VertexOut outline_vertex(VertexIn in                      [[stage_in]],
                                constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                                constant MyNodeBuffer& scn_node [[buffer(1)]])
{
    float3 modelNormal = normalize(in.normal);
    float3 modelPosition = in.position;
    float2 texture = in.texcord;
  
    
    const float extrusionValue = 0.4;
//  change this value to make outline smaller or bigger
    modelPosition += modelNormal * extrusionValue;
    
    
    VertexOut out;
    out.position = scn_node.modelViewProjectionTransform * float4(modelPosition, 1);
    
    out.color = float4(0, 0, 0, 1.0);
//  here you can change color of outline effect (r, g, b, a)
    
    
    out.normal = (scn_node.normalTransform * float4(in.normal, 1)).xyz;
    out.texcord = texture;

    return out;
}

fragment half4 outline_fragment(VertexOut in [[stage_in]],
                                texture2d<float, access::sample> texture [[texture(SCNVertexSemanticTexcoord0)]]) {

    constexpr sampler sampler2d(coord::normalized,filter::linear, address::repeat);
    float2 uv = in.texcord;
    float4 color = texture.sample(sampler2d, uv)*in.color;

    return half4(color);
}
