shader_type spatial;

uniform vec3 albedo : source_color;
uniform float metallic : hint_range(0, 1) = 0;
uniform float roughness : hint_range(0, 1) = 0.02;

// Height of the wave, movement of waves
uniform sampler2D wave;
uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;

// Direction of the waves1 and waves2
uniform vec2 wave_direction = vec2(2.0, 0.0);
uniform vec2 wave_direction2 = vec2(0.0, 1.0);

// How fast the waves move
uniform float time_scale : hint_range(0, 0.2, 0.005) = 0.025;

uniform float noise_scale = 10.0;
uniform float height_scale = 0.15;

// Varying variables (this makes the shader scalable we can stretch it!)
varying float height;
varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	height = texture(wave, world_pos.xz / noise_scale + TIME * time_scale).r;
	VERTEX.y += height * height_scale;

	//height = texture(wave, UV / noise_scale + TIME * time_scale).r;
	//VERTEX.y += height * height_scale;
}

// TODO: fresnel effect?

void fragment() {
	vec2 time = (TIME * wave_direction) * time_scale;
	vec2 time2 = (TIME * wave_direction2) * time_scale;
	
	//vec3 normal_blend = mix(texture(texture_normal, UV + time).rgb, texture(texture_normal2, UV + time2).rgb, 0.5);
	vec3 normal_blend = mix(texture(texture_normal, world_pos.xz + time).rgb, texture(texture_normal2, world_pos.xz + time2).rgb, 0.5);
	ALBEDO = albedo;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal_blend;
	// Place fragment code here.
}
