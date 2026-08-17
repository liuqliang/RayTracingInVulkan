#version 460
#extension GL_EXT_ray_tracing : require
#extension GL_GOOGLE_include_directive : require

#include "RayPayload.glsl"

layout(binding = 0, set = 0) uniform accelerationStructureEXT Scene;
layout(location = 0) rayPayloadInEXT RayPayload Ray;
hitAttributeEXT vec2 HitAttributes;

void main()
{
    const vec3 parentOrigin = gl_WorldRayOriginEXT;
    const vec3 parentDirection = gl_WorldRayDirectionEXT;
    const float parentT = gl_HitTEXT;

    traceRayEXT(Scene, gl_RayFlagsOpaqueEXT, 0xff,
                0, 0, 0, vec3(1000000.0), 0.001,
                vec3(1.0, 0.0, 0.0), 1.0, 0);

    const bool parentRestored =
        all(equal(parentOrigin, gl_WorldRayOriginEXT)) &&
        all(equal(parentDirection, gl_WorldRayDirectionEXT)) &&
        parentT == gl_HitTEXT;
    Ray.ColorAndDistance = parentRestored
        ? vec4(0.125, 0.875, 0.25, parentT)
        : vec4(1.0, 0.0, 0.0, -2.0);
}
