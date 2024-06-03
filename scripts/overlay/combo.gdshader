shader_type canvas_item;

uniform float progress : hint_range(0.0,100.0) = 100.0;
varying float pos;
uniform float width = 600.0;

void vertex() {
    pos = VERTEX.x*100.0/width;
    if (pos > progress-10.0) {
        VERTEX.x += pos-progress+10.0;
    }
}

void fragment() {
    if ((pos) >= (progress)) {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}