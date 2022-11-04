extends Control

export var ON : bool = false

func _ready():
	if ON and not SettingsMenu.played_splash:
		SettingsMenu.played_splash = true
		Music.stream_paused = true
		$SplashBG.visible = true
		$ArmorGamesSplash.visible = true
		$ArmorGamesSplash.play()
		$SplashButton.visible = true
		yield($ArmorGamesSplash, "finished")
		Music.stream_paused = false
		$SplashBG.visible = false
		$ArmorGamesSplash.visible = false
		$SplashButton.visible = false
	elif SettingsMenu.played_splash:
		$SplashBG.visible = false
		$ArmorGamesSplash.visible = false
		$SplashButton.visible = false


func _on_Logo_pressed():
	if ON:
		var _err = OS.shell_open("https://armor.ag/MoreGames")


func _on_PlayMoreGames_pressed():
	if ON:
		var _err = OS.shell_open("https://armor.ag/MoreGames")


func _on_LikeUs_pressed():
	if ON:
		var _err = OS.shell_open("https://www.twitter.com/ArmorGames")


func _on_SplashButton_pressed():
	if ON:
		var _err = OS.shell_open("https://armor.ag/MoreGames")
