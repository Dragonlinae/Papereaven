shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float offsetX : hint_range(-100.0, 100.0);
uniform float offsetY : hint_range(-100.0, 100.0);

void fragment() {
    vec4 foreground = textureLod(screen_texture, SCREEN_UV, 0.0);
    // get z offset between the foreground and the background
    // get position relative to center of the screen
    vec2 pos = SCREEN_UV - vec2(0.5, 0.5);
    vec4 foregroundoffset = textureLod(screen_texture, SCREEN_UV + vec2(offsetX * SCREEN_PIXEL_SIZE.x * pos.x, offsetY * SCREEN_PIXEL_SIZE.y * pos.y), 0.0);
    if(abs(foreground.r-0.3) + abs(foreground.g-0.3) + abs(foreground.b-0.3) > 0.1) {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    } else if (abs(foregroundoffset.r-0.3) + abs(foregroundoffset.g-0.3) + abs(foregroundoffset.b-0.3) > 0.1 && foregroundoffset.a != 0.99) {
        COLOR = vec4(0.9, 0.0, 0.0, 1.0);
    } else {
        COLOR = foreground;
    }
}