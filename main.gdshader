shader_type canvas_item;

uniform vec2 blur_direction = vec2(0.0, 5.0);
uniform int samples = 5;

void fragment() {
    vec4 color = vec4(0.0);
    vec2 tex_coord = UV;
    vec2 step_size = (blur_direction * SCREEN_PIXEL_SIZE) / float(samples);

    for (int i = 0; i < samples; i++) {
        color += texture(TEXTURE, tex_coord);
        tex_coord += step_size;
    }

    COLOR = color / float(samples);
}