shader_type spatial;

uniform sampler2D depth_texture : hint_depth_texture;

void fragment() {
	float depth = texture(depth_texture, UV).r;
	
	ALBEDO.rgb = vec3(depth);
}
