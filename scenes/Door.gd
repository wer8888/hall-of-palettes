extends Sprite
class_name Door

signal creature_touched(creature)

func _on_Area2D_body_entered(body):
	if body is Creature:
		emit_signal("creature_touched", body)


func _process(_delta):
	for body in $Area2D.get_overlapping_bodies():
		emit_signal("creature_touched", body)


func open():
	$AnimationPlayer.play("open")
	$DoorOpen.play()
