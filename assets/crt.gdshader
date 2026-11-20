shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.22;
uniform float scanline_count : hint_range(50.0, 800.0) = 240.0;
uniform float curvature : hint_range(0.0, 0.25) = 0.05;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.35;

vec2 warp_uv(vec2 uv){
	vec2 centered = uv * 2.0 - 1.0;
	vec2 offset = centered.yx * curvature;
	centered = centered + centered * offset * offset;
	return centered * 0.5 + 0.5;
}

void fragment(){
	vec2 uv = warp_uv(SCREEN_UV);
	vec3 col = vec3(0.0);

	if(uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0) {
		col = texture(screen_tex, uv).rgb;

		float scan = sin(uv.y * scanline_count * 3.14159) * 0.5 + 0.5;
		col *= mix(1.0, scan, scanline_strength);

		vec2 vig_uv = uv * (1.0 - uv.yx);
		float vig = pow(vig_uv.x * vig_uv.y * 15.0, vignette_strength);
		col *= clamp(vig, 0.0, 1.0);
	}
	COLOR = vec4(col, 1.0);

}
