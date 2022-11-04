extends Camera2D
class_name ScreenShakeCamera

var shaking := false
var decay = 100
onready var initial_pos := position

const DECAY_RATE = 10
const AMPLITUDE = 0.1


func shake():
	shaking = true
	decay = 100


func _process(_delta):
	if not shaking: return
	
	decay -= DECAY_RATE
	var offset = sin(decay) * decay
	position.x = initial_pos.x + (offset * AMPLITUDE)
	
	if decay <= 0:
		shaking = false
