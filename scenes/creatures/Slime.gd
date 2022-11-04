extends Creature
class_name Slime

signal spawn_key(slime_pos)

const MAX_PATROL_SPEED = 40
const MAX_SPEED = 70
const ACCELERATION = 1500
const JUMP_POWER = 260
const STOMP_POWER = 330

export var has_key : bool
var moving_right : bool = true
var in_air : bool = true

func _ready():
	if has_key:
		$KeyShadow.visible = true


func _moveAsPlayer(delta):
	
	if Input.is_action_pressed("move_left"):
		vel.x -= ACCELERATION * delta
	elif Input.is_action_pressed("move_right"):
		vel.x += ACCELERATION * delta
	else:
		vel.x = lerp(vel.x, 0, 0.3)
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = min(vel.y, -JUMP_POWER)
		$Jump.play()
		in_air = true
	
	moving_right = not sprite.flip_h
	animate()


func _moveAsEnemy(delta):
	vel.x = clamp(vel.x, -MAX_PATROL_SPEED, MAX_PATROL_SPEED)
	if moving_right:
		vel.x += ACCELERATION * delta
	else:
		vel.x -= ACCELERATION * delta
	animate()


func animate():
	
	var moving = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
	var walking = (
		is_on_floor() and
		((not is_player and not is_zero_approx(vel.x)) or
		(is_player and moving))
	)
	
	if vel.y > 0 and not is_on_floor():
		sprite.play("fall")
	elif vel.y < 0:
		sprite.play("jump")
	elif walking:
		sprite.play("walk")
	else:
		sprite.play("default")


func _processCollision(collision : KinematicCollision2D):
	var col = collision.collider
	var stomping = (
		self.get_script() == col.get_script() and
		is_on_floor() and
		collision.normal.is_equal_approx(UP)
	)
	if stomping:
		print(name + " stomp")
		vel.y = -STOMP_POWER
		$Jump.play()
		in_air = true
		col.die()
	
	var is_bumping_into = (
		not is_player and
		(col is Creature or col is TileMap or col is StaticBody2D) and
		(collision.normal.is_equal_approx(Vector2.LEFT) or
		collision.normal.is_equal_approx(Vector2.RIGHT) )
	)
	if is_bumping_into:
		moving_right = not moving_right
	
	var is_landing = (
		in_air and
		col is TileMap and
		collision.normal.is_equal_approx(UP)
	)
	if is_landing:
		in_air = false
		$Land.play()
	

func _dieEffect():
	if has_key:
		emit_signal("spawn_key", position)
		$KeyShadow.visible = false


func _on_LedgeDetectorLeft_body_exited(body):
	var turn_around = (
		not is_player and
		is_on_floor() and
		body != self and
		(body is Creature or body is TileMap) and
		not moving_right
	)
	if turn_around:
		moving_right = true


func _on_LedgeDetectorRight_body_exited(body):
	var turn_around = (
		not is_player and
		is_on_floor() and
		body != self and
		(body is Creature or body is TileMap) and
		moving_right
	)
	if turn_around:
		moving_right = false
