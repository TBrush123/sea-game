shader_type canvas_item;

uniform float reveal_amount : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (UV.x < reveal_amount) {
        tex_color.a = 0.0;
    }
    COLOR = tex_color;
}