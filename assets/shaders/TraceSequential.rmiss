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

void main()
{
    if (Ray.Phase == 1u)
    {
        Ray.Result += vec4(0.5, 0.25, 0.125, 0.0);
        Ray.VisitedMask |= 2u;
    }
    else
    {
        Ray.Result = vec4(1.0, 0.0, 1.0, 0.0);
        Ray.VisitedMask = 0u;
        Ray.Error = 1u;
    }
}
