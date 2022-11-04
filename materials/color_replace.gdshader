shader_type canvas_item;

uniform float threshold : hint_range(0,1) = 0.01;
uniform vec4 old_dark : hint_color;
uniform vec4 old_med : hint_color;
uniform vec4 old_accent : hint_color;
uniform vec4 old_light : hint_color;
uniform vec4 new_dark : hint_color;
uniform vec4 new_med : hint_color;
uniform vec4 new_accent : hint_color;
uniform vec4 new_light : hint_color;

bool isSameColor(vec4 color, vec4 compareTo) {
	
	if (distance(color, compareTo) < threshold)
		return true;
	else
		return false;
}

void fragment() {
	
	vec4 current_pixel = texture(TEXTURE, UV);
	
	if (isSameColor(current_pixel, old_dark))
		COLOR = new_dark;
	else if (isSameColor(current_pixel, old_med))
		COLOR = new_med;
	else if (isSameColor(current_pixel, old_accent))
		COLOR = new_accent;
	else if (isSameColor(current_pixel, old_light))
		COLOR = new_light;
	else
		COLOR = current_pixel;
	
}