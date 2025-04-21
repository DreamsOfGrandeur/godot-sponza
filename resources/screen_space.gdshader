shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

uniform float size = 2.0;


void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}


void fragment() {
	vec2 pixel_size = vec2(1.0) / VIEWPORT_SIZE;

	float peak_luma = 0.0;
	vec3 color = vec3(0.0);
	for (float x = -size; x < size; x++) {
		for (float y = -size; y < size; y++) {
			if (!(distance(vec2(x, y), vec2(0, 0)) <= size)) { continue; }

			vec3 col = texture(screen_texture, SCREEN_UV + vec2(x, y) * pixel_size).rgb;
			float luma = dot(col.rgb, vec3(0.299, 0.587, 0.114));

			if (luma > peak_luma) {
				peak_luma = luma;
				color = col;
			}
		}
	}
	float depth = texture(depth_texture, SCREEN_UV).r;
	vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
	ALBEDO = mix(color, screen_color, depth);
}
