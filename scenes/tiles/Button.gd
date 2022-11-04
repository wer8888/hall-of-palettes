extends Node2D

onready var area = $PressArea
onready var sprite = $Sprite
export(StreamTexture) var unpressed_texture
export(StreamTexture) var pressed_texture
export(Array, NodePath) var door
var _door : Array
var pressed : bool = false


func _ready():
	if door:
		for d in door:
			_door.append(get_node(d))
	else:
		push_warning("No corresponding door for button " + name)


func _process(_delta):
	var bodies = area.get_overlapping_bodies()
	if bodies.size() < 1:
		setPressed(false)
	
	for b in bodies:
		if b is Creature:
			setPressed(true)


func setPressed(val : bool):
	if val:
		if not pressed:
			$Press.play()
		pressed = true
		for d in _door:
			d.setOpen(true)
		sprite.texture = pressed_texture
	else:
		pressed = false
		for d in _door:
			d.setOpen(false)
		sprite.texture = unpressed_texture
