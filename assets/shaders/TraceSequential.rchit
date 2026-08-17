#version 460
#extension GL_EXT_ray_tracing : require

struct SequentialPayload
{
    vec4 Result;
    uint Phase;
    uint VisitedMask;
    uint Error;
};

layout(location = 0) rayPayloadInEXT SequentialPayload Ray;
hitAttributeEXT vec2 HitAttributes;

void main()
{
    if (Ray.Phase == 0u)
    {
        Ray.Result += vec4(0.125, 0.25, 0.5, 0.0);
        Ray.VisitedMask |= 1u;
    }
    else
    {
        Ray.Result = vec4(1.0, 0.0, 1.0, 0.0);
        Ray.VisitedMask = 0u;
        Ray.Error = 1u;
    }
}
