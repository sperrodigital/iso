shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1, 1, 1, 1);
uniform float outline_size : hint_range(0, 10) = 2.0;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    
    // Sample neighbors to detect edges
    float alpha = col.a;
    alpha = max(alpha, texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x * outline_size, 0)).a);
    alpha = max(alpha, texture(TEXTURE, UV - vec2(TEXTURE_PIXEL_SIZE.x * outline_size, 0)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0, TEXTURE_PIXEL_SIZE.y * outline_size)).a);
    alpha = max(alpha, texture(TEXTURE, UV - vec2(0, TEXTURE_PIXEL_SIZE.y * outline_size)).a);
    
    // Draw outline where sprite isn't but neighbors are
    if (col.a < 0.1 && alpha > 0.1) {
        COLOR = outline_color;
    } else {
        COLOR = col;
    }
}