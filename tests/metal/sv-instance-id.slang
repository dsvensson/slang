// [[instance_id]] counts from the base instance, SV_InstanceID counts from zero, and
// SV_VulkanInstanceID has gl_InstanceIndex semantics, so only SV_InstanceID subtracts.

//TEST:SIMPLE(filecheck=HLSL): -target metal -stage vertex -entry vertMain
//TEST:SIMPLE(filecheck=VULKAN): -target metal -stage vertex -entry vertVulkan
//TEST:SIMPLE(filecheck=BOTH): -target metal -stage vertex -entry vertBoth
//TEST:SIMPLE(filecheck=METALLIB): -target metallib -stage vertex -entry vertMain
//TEST:SIMPLE(filecheck=METALLIB): -target metallib -stage vertex -entry vertBoth

// METALLIB: result code = 0

// HLSL-DAG: instance_id]]
// HLSL-DAG: base_instance]]
// HLSL: int(i{{[0-9_]*}}) - int(base_instance{{[0-9_]*}})
[shader("vertex")]
float4 vertMain(int i : SV_InstanceID) : SV_Position
{
    return i;
}

// VULKAN: instance_id]])
// VULKAN-NOT: base_instance
[shader("vertex")]
float4 vertVulkan(uint i : SV_VulkanInstanceID) : SV_Position
{
    return i;
}

// An explicit SV_StartInstanceLocation is reused rather than declared a second time.
// BOTH-DAG: instance_id]]
// BOTH-DAG: base_instance]]
// BOTH: i{{[0-9_]*}} - base{{[0-9_]*}} + base{{[0-9_]*}}
[shader("vertex")]
float4 vertBoth(uint i : SV_InstanceID, uint base : SV_StartInstanceLocation) : SV_Position
{
    return i + base;
}
