#version 460
#extension GL_GOOGLE_include_directive : require
#extension GL_EXT_ray_tracing : require

#include "RayPayload.glsl"

layout(location = 0) rayPayloadInEXT RayPayload Ray;
hitAttributeEXT vec2 HitAttributes;

void main()
{
    // The x component is the post-TraceRay checksum seed expected by raygen.
    Ray.ColorAndDistance = vec4(0.125, 0.875, 0.25, gl_HitTEXT);
}
