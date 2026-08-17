#version 460
#extension GL_EXT_ray_tracing : require
#extension GL_GOOGLE_include_directive : require

#include "RayPayload.glsl"

layout(location = 0) rayPayloadInEXT RayPayload Ray;

void main()
{
    Ray.ColorAndDistance = vec4(0.75, 0.125, 0.25, -1.0);
}
