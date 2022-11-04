extends StaticBody2D
class_name Statue

var creature = preload("res://scenes/creatures/Slime.tscn")
var crack_texture : StreamTexture = preload("res://sprites/creatures/statue_slime_crack.png")


func crack():
	$Sprite.texture = crack_texture
	$Crack.play()


func open(parent : Node) -> Creature:
	var new_creature = creature.instance()
	parent.add_child(new_creature)
	new_creature.position = position
	new_creature.get_node("Die").play()
	queue_free()
	return new_creature



