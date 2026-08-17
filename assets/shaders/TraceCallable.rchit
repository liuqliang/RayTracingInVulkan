#version 460
#extension GL_EXT_ray_tracing : require
#extension GL_GOOGLE_include_directive : require

#include "RayPayload.glsl"

struct CallableData
{
    vec4 Result;
    uint Guard;
};

layout(location = 0) rayPayloadInEXT RayPayload Ray;
layout(location = 1) callableDataEXT CallableData Call;
hitAttributeEXT vec2 HitAttributes;

void main()
{
    Call.Result = vec4(0.0);
    Call.Guard = 0x13579bdfu;
    executeCallableEXT(0, 1);
    Ray.ColorAndDistance =
        vec4(0.125, 0.25, 0.875, gl_HitTEXT) +
        (Call.Result - vec4(0.125, 0.875, 0.25, 1.0));
}
