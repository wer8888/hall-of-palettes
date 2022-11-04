extends AnimatedSprite
class_name Key

signal creature_touched(creature)

export var follow_weight : float = 0.025


func follow(pos : Vector2, hover_outside : bool):
	var follow_pos = pos
	if hover_outside:
		var direction = (position - pos).normalized()
		follow_pos = pos + (direction * 16)
	position = lerp(position, follow_pos, follow_weight)


func _on_Area2D_body_entered(body):
	if body is Creature:
		emit_signal("creature_touched", body)
