shader_type canvas_item;

const vec4 damage_color = vec4(1.0, 1.0, 1.0, 1.0);
const float intensity = 0.0;

void fragment() {
  // color data for textured parts of sprite
  vec4 color = texture(TEXTURE, UV);
  
  // linearly mixes the texture color with the damage color
  color.rgb = mix(color.rgb, damage_color.rgb, intensity);
  
  COLOR = color;
}