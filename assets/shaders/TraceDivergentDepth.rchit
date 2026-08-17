#version 460
#extension GL_EXT_ray_tracing : require

struct DivergentPayload
{
    uint RemainingDepth;
    uint ObservedDepth;
    uint Error;
};

layout(binding = 0, set = 0) uniform accelerationStructureEXT Scene;
layout(location = 0) rayPayloadInEXT DivergentPayload Ray;
hitAttributeEXT vec2 HitAttributes;

void main()
{
    const uint remaining = Ray.RemainingDepth;
    if (remaining == 0u)
    {
        Ray.ObservedDepth = 1u;
        return;
    }

    const vec3 parentOrigin = gl_WorldRayOriginEXT;
    const vec3 parentDirection = gl_WorldRayDirectionEXT;
    const float parentT = gl_HitTEXT;
    Ray.RemainingDepth = remaining - 1u;
    traceRayEXT(Scene, gl_RayFlagsOpaqueEXT, 0xff,
                0, 0, 0, parentOrigin, 0.001,
                parentDirection, 10000.0, 0);

    if (!all(equal(parentOrigin, gl_WorldRayOriginEXT)))
        Ray.Error = 1u;
    if (!all(equal(parentDirection, gl_WorldRayDirectionEXT)))
        Ray.Error = 1u;
    if (parentT != gl_HitTEXT)
        Ray.Error = 1u;
    if (Ray.RemainingDepth != 0u)
        Ray.Error = 1u;
    if (Ray.ObservedDepth != remaining)
        Ray.Error = 1u;
    Ray.ObservedDepth += 1u;
}
