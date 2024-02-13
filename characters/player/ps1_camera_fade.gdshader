
shader_type canvas_item;

// 0 = No fade.
// 255 = Totally dark.
uniform int alpha: hint_range(0, 255);

void fragment() {
	vec3 color = texelFetch(TEXTURE, ivec2(FRAGCOORD.xy), 0).rgb;
	
	// Convert 0 to 255 to 0 to 1.
	float decimal_alpha = float(alpha) / 255.0;
	
	// Quantize to make it a bit more "jumpy".
	decimal_alpha = floor(decimal_alpha * 32.0) / 32.0;
	
	// Equal to GL_FUNC_REVERSE_SUBTRACT.
	COLOR.rgb = color - vec3(decimal_alpha);
}