shader_type canvas_item;

// vignette shader

void fragment() {
    vec2 pos = UV - vec2(0.5, 0.5);
    pos.x = pos.x * TEXTURE_PIXEL_SIZE.x;
    pos.y = pos.y * TEXTURE_PIXEL_SIZE.y;
    float distance = length(pos);
    distance = smoothstep(0, 1.0, distance);
    COLOR = vec4(0.0, 0.0, 0.0, distance);
}