shader_type spatial;


uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec3 color_test : source_color = vec3(1, 1, 1);
uniform float color_predominance : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float luminosity_mult : hint_range(0.0, 10.0) = 6.0;
uniform float luminosity_2 = 10.0;
uniform float glow_threshold = 0.07;
uniform float glow_mult = 10.0;


float noise(vec2 input) {
	return fract(sin(dot(input, vec2(12.25, 10.356)) * 23.2) * 1054.52);
}


void fragment() {
	vec3 back_color = texture(screen_texture, SCREEN_UV).rgb * 10.0 * luminosity_mult;

	if(length(back_color) < glow_threshold) {
		back_color = back_color * glow_mult;
	}

	vec3 inverted_color = 1.0 - back_color * (luminosity_2 * noise(SCREEN_UV));

	ALBEDO = back_color * - 20.0 * inverted_color;

	ALBEDO = ( (ALBEDO * (vec3(1) - color_predominance)) + (color_test * color_predominance) ) * color_test;
}