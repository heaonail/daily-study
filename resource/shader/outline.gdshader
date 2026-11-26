shader_type canvas_item;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 2.0;
uniform float glow_intensity : hint_range(0.0, 5.0) = 1.5;
void fragment() {
vec4 color = texture(TEXTURE, UV);
vec2 size = TEXTURE_PIXEL_SIZE * outline_width;
}