shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 foreground = textureLod(screen_texture, SCREEN_UV, 0.0);
    vec2 pos = SCREEN_UV - vec2(0.5, 0.5);
    if(foreground.gb == vec2(0.0, 0.0) && abs(foreground.r-0.9) < 0.01) {
        COLOR = mix(COLOR, vec4(0.0, 0.0, 0.0, 1.0), 0.5);
    } else if(abs(foreground.r-0.3) + abs(foreground.g-0.3) + abs(foreground.b-0.3) > 0.1) {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}