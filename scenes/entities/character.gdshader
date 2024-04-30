shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
uniform float line_thickness : hint_range(0, 100) = 100.0;
uniform sampler2D paper : hint_default_white;

const vec2 OFFSETS[8] = {
	vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1), 
	vec2(1, -1), vec2(1, 0), vec2(1, 1)
};

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	float outline = 0.0;
	
	for (float j = 0.0; j < line_thickness; j+=5.0) {
		size = TEXTURE_PIXEL_SIZE * j;
		for (int i = 0; i < OFFSETS.length(); i++) {
			outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
		}
	}
	outline = min(outline, 1.0);
	
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, line_color, outline - color.a);

	// get a unique random value from the COLOR
	float randval = rand(vec2(outline, color.a));

	// randomize paper texture offset
	vec2 randUV = UV + vec2(randval*7.0, randval) * 0.01;

	// tile the paper texture
	randUV = fract(randUV);

	// apply paper texture
	COLOR = mix(COLOR, texture(paper, randUV), COLOR.a - color.a);
}