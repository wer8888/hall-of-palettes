extends GridContainer

signal changed
signal exited

func _ready():
	for button in get_children():
		if button.name != "Exit":
			button.connect("pressed", self, "levelButtonPressed", [button.name])


func levelButtonPressed(name : String):
	emit_signal("changed")
	LevelTransition.changeScene("scenes/levels/" + name + ".tscn")


func _on_Exit_pressed():
	emit_signal("exited")
