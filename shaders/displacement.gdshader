shader_type spatial;
uniform sampler2D screen_tex: hint_screen_texture;


float rand(float n){return fract(sin(n) * 43758.5453123);}


float vrand (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}


float simplex(vec2 n) {
    const vec2 d = vec2(0.0, 1.0);
  vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
    return mix(mix(vrand(b), vrand(b + d.yx), f.x), mix(vrand(b + d.xy), vrand(b + d.yy), f.x), f.y);
}

void fragment() {
    ALBEDO = texture(screen_tex, SCREEN_UV + .03 * simplex(SCREEN_UV + TIME)).rgb * 30.0;
}