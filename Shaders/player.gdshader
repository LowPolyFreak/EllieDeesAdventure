shader_type spatial;

uniform vec3 albedo : source_color;
uniform vec3 fresnel_color : source_color;
uniform float intensity: hint_range(0.0, 20.0, 0.01) = 1.0;
uniform float amount: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float emmission_multiplier = 1.0; 

vec3 fresnel_glow(vec3 color, vec3 normal, vec3 view)
{
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void fragment()
{
	vec3 base_color = vec3(0.5, 0.2, 0.9);
	//vec3 fresnel_color = vec3(0.0, 0.7, 0.9);
	vec3 fresnel = fresnel_glow(fresnel_color, NORMAL, VIEW);
	ALBEDO = albedo + fresnel;
	EMISSION = albedo + fresnel;
}