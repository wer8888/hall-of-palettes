extends Creature
class_name Bat

const X_MAX_SPEED = 60
const Y_MAX_SPEED = 80
const X_ACCELERATION = 500
const Y_ACCELERATION = 1500

onready var anim_player = $AnimationPlayer


func _moveAsPlayer(delta):
	vel.x = clamp(vel.x, -X_MAX_SPEED, X_MAX_SPEED)
	vel.y = clamp(vel.y, -Y_MAX_SPEED, Y_MAX_SPEED)
	
	if Input.is_action_pressed("move_left"):
		vel.x -= X_ACCELERATION * delta
	elif Input.is_action_pressed("move_right"):
		vel.x += X_ACCELERATION * delta
	else:
		vel.x = lerp(vel.x, 0, 0.5)
	
	if Input.is_action_pressed("jump"):
		vel.y -= Y_ACCELERATION * delta
	
	animate()


func _moveAsEnemy(delta):
	animate()
	vel.x = lerp(vel.x, 0, 0.1)
	vel.y -= Y_ACCELERATION * delta
	vel.y = clamp(vel.y, -Y_MAX_SPEED, Y_MAX_SPEED)

func animate():
	var col := get_last_slide_collision()
	if col and (col.collider is TileMap or col.collider is StaticBody2D):
		if is_on_ceiling() and is_zero_approx(vel.x):
			anim_player.play("perch")
		elif is_on_floor() and is_zero_approx(vel.x):
			anim_player.play("stand")
		else:
			anim_player.play("flap")
			#if not $Flap.playing:
				#$Flap.play()
	else:
		anim_player.play("flap")
		#if not $Flap.playing:
			#$Flap.play()
