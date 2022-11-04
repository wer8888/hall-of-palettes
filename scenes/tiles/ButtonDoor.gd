extends StaticBody2D
class_name ButtonDoor

var open_texture : StreamTexture = preload("res://sprites/tiles/button_door_open.png")
var closed_texture : StreamTexture = preload("res://sprites/tiles/button_door.png")
onready var collider = $CollisionShape2D


func setOpen(open : bool):
	if open:
		$Sprite.texture = open_texture
		collider.disabled = true
		pass
	else:
		$Sprite.texture = closed_texture
		collider.disabled = false
		pass
	
