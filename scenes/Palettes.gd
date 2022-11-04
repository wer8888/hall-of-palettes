extends Node

const GREYSCALE = -1
const GREEN = 0
const BLUE = 1
const RED = 2

var current_palette := 0
var deaths_amount := 0
var level_skips := 0

const PALETTE_VALUES = {
	-1 : [Color("444444"), Color("717171"), Color("9A9A9A"), Color("C2C2C2")], #greyscale
	GREEN : [Color("405010"), Color("708028"), Color("a0a840"), Color("d0d058")],
	BLUE : [Color("622e4c"), Color("7550e8"), Color("608fcf"), Color("8be5ff")],
	RED : [Color("7c3f58"), Color("eb6b6f"), Color("f9a875"), Color("fff6d3")]
}

func setPalette(material : ShaderMaterial, palette : int):
	current_palette = palette
	var new_palette = PALETTE_VALUES[palette]
	material.set_shader_param("new_dark", new_palette[0])
	material.set_shader_param("new_med", new_palette[1])
	material.set_shader_param("new_accent", new_palette[2])
	material.set_shader_param("new_light", new_palette[3])


func getColor(type : int) -> Color:
	return PALETTE_VALUES[current_palette][type]
