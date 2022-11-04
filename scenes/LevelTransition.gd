extends CanvasLayer

signal done_transition
onready var anim_player = $AnimationPlayer

func changeScene(target : String):
	
	if get_tree().get_current_scene() is Level:
		get_tree().get_current_scene().current_game_state = Level.GameState.TRANSITION
	
	$TransitionSFX.play()
	anim_player.play("cover")
	yield(anim_player, "animation_finished")
	
	var _err = get_tree().change_scene(target)
	anim_player.play("decover")
	
	yield(anim_player, "animation_finished")
	emit_signal("done_transition")
