#version 460
#extension GL_EXT_ray_tracing : require
#extension GL_GOOGLE_include_directive : require

#include "RayPayload.glsl"

layout(binding = 0, set = 0) uniform accelerationStructureEXT Scene;
layout(location = 0) rayPayloadInEXT RayPayload Ray;
hitAttributeEXT vec2 HitAttributes;

void main()
{
    traceRayEXT(Scene, gl_RayFlagsOpaqueEXT, 0xff,
                0, 0, 0, gl_WorldRayOriginEXT, 0.001,
                gl_WorldRayDirectionEXT, 10000.0, 0);
    Ray.ColorAndDistance = vec4(1.0, 0.0, 1.0, -3.0);
}
