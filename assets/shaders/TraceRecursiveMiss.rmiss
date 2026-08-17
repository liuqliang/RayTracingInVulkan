#version 460
#extension GL_EXT_ray_tracing : require
#extension GL_GOOGLE_include_directive : require

#include "RayPayload.glsl"

layout(binding = 0, set = 0) uniform accelerationStructureEXT Scene;
layout(location = 0) rayPayloadInEXT RayPayload Ray;

void main()
{
    if (Ray.ScatterDirection.w < 0.5) {
        const vec3 parentOrigin = gl_WorldRayOriginEXT;
        const vec3 parentDirection = gl_WorldRayDirectionEXT;
        Ray.ScatterDirection.w = 1.0;

        traceRayEXT(Scene, gl_RayFlagsOpaqueEXT, 0xff,
                    0, 0, 0, vec3(2000000.0), 0.001,
                    vec3(0.0, 1.0, 0.0), 1.0, 0);

        const bool parentRestored =
            all(equal(parentOrigin, gl_WorldRayOriginEXT)) &&
            all(equal(parentDirection, gl_WorldRayDirectionEXT));
        const bool childPayloadVisible =
            all(equal(Ray.ColorAndDistance.rgb, vec3(0.75, 0.125, 0.5)));
        Ray.ColorAndDistance = parentRestored && childPayloadVisible
            ? vec4(0.625, 0.375, 0.125, -1.0)
            : vec4(1.0, 0.0, 0.0, -2.0);
    } else {
        Ray.ColorAndDistance = vec4(0.75, 0.125, 0.5, -1.0);
    }
}
