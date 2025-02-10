shader_type spatial;


uniform sampler2D albedo;


void fragment() {
	vec4 albedo_texture = texture(albedo, UV * 80.0);

	ALBEDO = albedo_texture.rgb;
	ALPHA = albedo_texture.a;
}
