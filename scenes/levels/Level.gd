 extends Node2D
class_name Level

var current_palette = 0
export var level_palettes := {
	Palettes.GREEN : null,
	Palettes.BLUE : null,
	Palettes.RED : null
}
export(NodePath) var statue_path = null
var statue : Statue = null
var cracked_open_statue : bool = false
onready var current_player = get_node(level_palettes[Palettes.GREEN])
enum GameState { INACTIVE, NEUTRAL, HAS_KEY, OPENING_DOOR, DONE, TRANSITION }
var current_game_state = GameState.INACTIVE

var camera : ScreenShakeCamera = null

onready var key : Key = $Key
onready var door : Door = $Door
onready var message = $UI/Message
var door_counter = 0

export var next_level_path : String

func _ready():
	Music.unmuffle()
	current_player.is_player = true
	for palette in level_palettes.keys():
		var creature = level_palettes[palette]
		if not creature:
			var _is = level_palettes.erase(palette)
		else:
			var node = get_node(creature)
			level_palettes[palette] = node
			node.connect("died", self, "creatureDied", [node])
			if node is Slime:
				node.connect("spawn_key", self, "moveKey")
	Palettes.setPalette(material, Palettes.GREEN)
	message.add_color_override("font_color", Palettes.PALETTE_VALUES[Palettes.GREEN][3])
	message.add_color_override("font_color_shadow", Palettes.PALETTE_VALUES[Palettes.GREEN][0])
	
	if statue_path:
		statue = get_node(statue_path)
		cracked_open_statue = false
	
	if has_node("ScreenShakeCamera"):
		camera = $ScreenShakeCamera
	
	yield(get_tree().create_timer(0.3), "timeout")
	current_game_state = GameState.NEUTRAL


func _process(_delta):
	if current_game_state == GameState.INACTIVE or current_game_state == GameState.TRANSITION: 
		return
	
	if Input.is_action_just_pressed("reset"):
		current_game_state = GameState.INACTIVE
		Palettes.deaths_amount += 1
		LevelTransition.changeScene(get_tree().current_scene.filename)
		return
	elif Input.is_action_just_pressed("skip_level"):
		nextLevel()
		Palettes.level_skips += 1
		return
	elif Input.is_action_just_pressed("pause"):
		SettingsMenu.toggle(true)
		return
	
	if current_game_state == GameState.OPENING_DOOR:
		key.follow(door.position, false)
		door_counter += 1
		if key.position.distance_to(door.position) <= 1 or door_counter >= 30:
			key.queue_free()
			current_game_state = GameState.DONE
			door.open()
	elif current_game_state == GameState.HAS_KEY:
		key.follow(current_player.position, true)
	
	if Input.is_action_just_pressed("change_palette") and current_palette != -1:
		cyclePalette()


func cyclePalette(add : bool = true):
	if level_palettes.size() < 1 or current_palette == -1:
		return
	if add:
		current_palette += 1
	var palettes = level_palettes.keys()
	if current_palette >= palettes.size():
		current_palette -= palettes.size()
	Palettes.setPalette(material, palettes[current_palette])
	if current_player != level_palettes[palettes[current_palette]]:
		setPlayer(level_palettes[palettes[current_palette]])
		$PaletteSwitchSFX.play()
	
	var cols = Palettes.PALETTE_VALUES[palettes[current_palette]]
	message.add_color_override("font_color", cols[3])
	message.add_color_override("font_color_shadow", cols[0])


func setPlayer(new_player : Creature):
	if current_player and is_instance_valid(current_player):
		current_player.setIsPlayer(false)
	current_player = new_player
	current_player.setIsPlayer(true)


func creatureDied(creature : Creature):
	print(creature.name + " has died!")
	var creatures = level_palettes.values()
	for i in range(creatures.size()):
		if creature == creatures[i]:
			if creature != current_player and current_palette != 0:
				current_palette -= 1
			var _is = level_palettes.erase(level_palettes.keys()[i])
			cyclePalette(false)
	if level_palettes.size() < 1:
		gameOver()


func _on_Key_creature_touched(creature):
	if creature == current_player and current_game_state == GameState.NEUTRAL:
		current_game_state = GameState.HAS_KEY
		$KeySFX.play()


func _on_Door_creature_touched(creature):
	if creature == current_player:
		if current_game_state == GameState.HAS_KEY:
			current_game_state = GameState.OPENING_DOOR
		elif current_game_state == GameState.DONE:
			nextLevel()
			


func nextLevel():
	current_game_state = GameState.TRANSITION
	LevelTransition.changeScene(next_level_path)


func moveKey(pos : Vector2):
	if pos and key:
		key.position = pos


func gameOver():
	print("game over")
	current_game_state = GameState.INACTIVE
	Palettes.setPalette(material, -1)
	current_palette = -1
	message.add_color_override("font_color", Palettes.PALETTE_VALUES[-1][3])
	message.add_color_override("font_color_shadow", Palettes.PALETTE_VALUES[-1][0])
	Music.muffle()
	yield(get_tree().create_timer(1), "timeout")
	
	if not cracked_open_statue and statue and camera:
		cracked_open_statue = true
		current_game_state = GameState.NEUTRAL
		print("cracking open statue")
		
		camera.shake()
		statue.crack()
		yield(get_tree().create_timer(1), "timeout")
		
		camera.shake()
		var creature = statue.open(self)
		creature.owner = self
		Palettes.setPalette(creature.material, -1)
		creature.connect("died", self, "gameOver")
		creature.setIsPlayer(true)
		current_player = creature
	else:
		Palettes.deaths_amount += 1
		LevelTransition.changeScene(get_tree().current_scene.filename)
