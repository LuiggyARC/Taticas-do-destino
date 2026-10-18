shader_type canvas_item;
uniform vec4 focus_rect = vec4(0.0, 0.0, 1.0, 1.0);

void fragment() {
	vec2 source_uv = focus_rect.xy + UV * focus_rect.zw;
	vec4 portrait = texture(TEXTURE, source_uv);
	float edge = length(UV - vec2(0.5));
	portrait.a *= 1.0 - smoothstep(0.465, 0.50, edge);
	COLOR = portrait;
}
