#version 460
#extension GL_EXT_ray_tracing : require
#extension GL_GOOGLE_include_directive : require

#include "RayPayload.glsl"

hitAttributeEXT vec4 ReportAttribute;
layout(location = 0) rayPayloadInEXT RayPayload Ray;

void main()
{
    Ray.ColorAndDistance = vec4(ReportAttribute.rgb, gl_HitTEXT);
}
