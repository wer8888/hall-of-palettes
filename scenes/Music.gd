extends AudioStreamPlayer


func muffle():
	AudioServer.set_bus_effect_enabled(1, 0, true)


func unmuffle():
	AudioServer.set_bus_effect_enabled(1, 0, false)
