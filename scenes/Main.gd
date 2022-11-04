extends Control

onready var initial_pos = $Title.rect_position
var counter := 0.0

const AMP = 5
const SPEED = 1.5

onready var buttons = $Buttons
onready var start = $Buttons/StartButton
onready var settings = $Buttons/Settings
onready var level_select = $LevelSelect


func _process(delta):
	counter += delta * SPEED
	$Title.rect_position.y = initial_pos.y + (sin(counter) * AMP)


func _on_StartButton_pressed():
	buttons.visible = false
	level_select.visible = true
	$Click.play()


func _on_LevelSelect_exited():
	buttons.visible = true
	level_select.visible = false
	$Click.play()


func _on_Settings_pressed():
	SettingsMenu.toggle(true)



