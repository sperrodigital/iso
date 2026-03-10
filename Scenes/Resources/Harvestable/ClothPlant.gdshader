shader_type canvas_item;

uniform float outline_width : hint_range(0.0, 10.0) = 1.5;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool outline_enabled = false;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    if (outline_enabled) {
        vec2 size = outline_width / vec2(textureSize(TEXTURE, 0));
        float alpha = texture(TEXTURE, UV + vec2(size.x, 0.0)).a
                    + texture(TEXTURE, UV - vec2(size.x, 0.0)).a
                    + texture(TEXTURE, UV + vec2(0.0, size.y)).a
                    + texture(TEXTURE, UV - vec2(0.0, size.y)).a;
        
        if (color.a < 0.1 && alpha > 0.0) {
            color = outline_color;
        }
    }
    
    COLOR = color;
}