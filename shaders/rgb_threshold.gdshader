// Made by me

shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform bool enabled;

uniform float threshold_r : hint_range(0.0, 1.0) = 0.5;
uniform float threshold_g : hint_range(0.0, 1.0) = 0.5;
uniform float threshold_b : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	if (!enabled) discard;

	vec4 screen_texture_color = texture(screen_texture, SCREEN_UV);

	float r;
	float g;
	float b;
	for (int i = 0; i < 3; i++) {
		float channel_color;
		float threshold;

		if (i == 0) {channel_color = screen_texture_color.r; threshold = threshold_r;}
		if (i == 1) {channel_color = screen_texture_color.g; threshold = threshold_g;}
		if (i == 2) {channel_color = screen_texture_color.b; threshold = threshold_b;}

		if (channel_color < threshold) {
			channel_color = 0.0;
		} else {
			channel_color = 1.0;
		}

		if (i == 0) {r = channel_color;}
		if (i == 1) {g = channel_color;}
		if (i == 2) {b = channel_color;}
	}
	vec4 thresholded_color = vec4(r, g, b, 1.0);

	COLOR = thresholded_color;
}
