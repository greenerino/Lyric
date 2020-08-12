shader_type canvas_item;

uniform bool active = true;

void fragment() { 
	vec4 prev = texture(TEXTURE, UV);
	vec4 white = vec4(1.0, 1.0, 1.0, prev.a);
    vec4 new = prev;
    if (active) {
        new = white;
    }
	COLOR = new;
}