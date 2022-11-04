extends CanvasLayer

signal exited

var paused = false
onready var click = $Menu/Click
var played_splash = false

func toggle(pause : bool):
	click.play()
	if pause:
		print("pause")
		paused = true
		$Menu.visible = true
		get_tree().paused = true
	else:
		print("unpause")
		paused = false
		$Menu.visible = false
		get_tree().paused = false
		emit_signal("exited")


func _process(_delta):
	if paused and Input.is_action_just_pressed("pause"):
		yield(get_tree(), "idle_frame")
		toggle(false)
		return


func _on_Music_toggled(button_pressed):
	click.play()
	AudioServer.set_bus_mute(1, not button_pressed)


func _on_Sound_toggled(button_pressed):
	click.play()
	AudioServer.set_bus_mute(2, not button_pressed)


func _on_MainMenu_pressed():
	toggle(false)
	LevelTransition.changeScene("res://scenes/Main.tscn")


func _on_LevelSelect_exited():
	toggle(false)


func _on_LevelSelect_changed():
	toggle(false)
