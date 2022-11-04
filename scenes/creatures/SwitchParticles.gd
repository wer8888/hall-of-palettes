extends CPUParticles2D
class_name SwitchParticles

func _ready():
	color = Palettes.getColor(1)
	emitting = true

func _on_Timer_timeout():
	queue_free()
