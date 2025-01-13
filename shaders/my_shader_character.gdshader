shader_type spatial;


uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


float noise(vec2 input) {
	return fract(sin(dot(input, vec2(12.25, 10.356)) * 23.2) * 1054.52);
}


void fragment() {
	vec3 back_color = texture(screen_texture, SCREEN_UV).rgb * 60.0;

	if(length(back_color) < 0.07) {
		back_color = back_color * 10.0;
	}
	vec3 inverted_color = 1.0 - back_color * (10.0 * noise(SCREEN_UV));


	ALBEDO = back_color * - 20.0 * inverted_color;
}
