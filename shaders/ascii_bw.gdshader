shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform bool use_colors = false;
uniform float character_pixel_size = 8.0;
uniform float nbr_of_lum_values = 10.0;
uniform float opacity = 1.0;

uniform sampler2D ascii_characters : repeat_enable, filter_nearest;

void fragment() {
	// Handle the pixelisation and quantization of the screen_texture
	vec2 uv_mult = vec2(1.0 / SCREEN_PIXEL_SIZE) * (1.0 / character_pixel_size);
	vec2 pix_uv = floor(UV * uv_mult) / uv_mult;
	vec4 pix_screen_texture = texture(screen_texture, pix_uv);
	float lum_value = (pix_screen_texture.r + pix_screen_texture.g + pix_screen_texture.b) / 3.0;
	float quantized_lum = floor(lum_value * nbr_of_lum_values) / nbr_of_lum_values;


	// Handle the ascii character based on luminance
	vec2 ascii_uv = fract(UV / (SCREEN_PIXEL_SIZE * character_pixel_size));

	if (quantized_lum >= 0.9000001) { ascii_uv.x = fract((ascii_uv.x + 9.0) / 10.0); }
	else { ascii_uv.x = fract((ascii_uv.x + (quantized_lum * 10.0)) / 10.0); }
	vec4 ascii_texture = texture(ascii_characters, ascii_uv);


	if (use_colors) {
		if (ascii_texture.r <= 0.0001) { COLOR = vec4(0, 0, 0, opacity); }
		else { COLOR = vec4(pix_screen_texture.rgb, opacity); }
	}
	else {
		COLOR = vec4(ascii_texture.rgb, opacity);
	}
}
