extends CPUParticles2D

signal done
onready var timer = $DeathParticleTimer

func play():
	emitting = true
	color = Palettes.getColor(1)
	timer.start()
	yield(timer, "timeout")
	emitting = false
	emit_signal("done")
	yield($DisappearTimer, "timeout")
	queue_free()
