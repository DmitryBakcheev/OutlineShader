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
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
    float4 color;
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
  
    const float extrusionValue = 0.4;
//  change this value to make outline smaller or bigger
    modelPosition += modelNormal * extrusionValue;
    
    
    VertexOut out;
    out.position = scn_node.modelViewProjectionTransform * float4(modelPosition, 1);
    out.normal = (scn_node.normalTransform * float4(in.normal, 1)).xyz;

    return out;
}

fragment half4 outline_fragment(VertexOut in [[stage_in]]) {
    
//  here you can change color of outline effect (r, g, b, a)
    return half4(0, 0, 0, 1);
}

