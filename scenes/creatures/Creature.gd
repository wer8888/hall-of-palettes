extends KinematicBody2D
class_name Creature

signal died

const UP = Vector2.UP
const GRAVITY = 720
const MAX_FALL_SPEED = 1000

export var palette = 0
export var use_gravity = true
var alive = true
var is_player = false
var vel = Vector2.ZERO
var acc = Vector2.ZERO
onready var sprite = $Sprite

onready var switch_particles = preload("res://scenes/creatures/SwitchParticles.tscn")
onready var death_particles = preload("res://scenes/creatures/DeathParticles.tscn")

func _ready():
	modulate = Color.white
	material = load("res://materials/standard_color_replace.tres").duplicate()
	Palettes.setPalette(material, palette)


func _physics_process(delta):
	if not alive: return
	if use_gravity:
		vel.y += GRAVITY * delta
		if vel.y > MAX_FALL_SPEED:
			vel.y = MAX_FALL_SPEED
	
	if is_player:
		_moveAsPlayer(delta)
	else:
		_moveAsEnemy(delta)
	
	if vel.x > 0:
		sprite.flip_h = false
	elif vel.x < 0:
		sprite.flip_h = true
	
	vel = move_and_slide(vel, UP)
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		_processCollision(collision)
		if collision.collider.is_in_group("danger"):
			die()


func setIsPlayer(set : bool):
	is_player = set
	if is_player:
		var particles = switch_particles.instance()
		owner.add_child(particles)
		particles.position = position


func _moveAsPlayer(_delta):
	pass


func _moveAsEnemy(_delta):
	pass


func die():
	if not alive: return
	alive = false
	
	_dieEffect()
	emit_signal("died")
	
	$Die.play()
	sprite.visible = false
	var particles = death_particles.instance()
	owner.add_child(particles)
	particles.position = position
	particles.play()
	yield(particles, "done")
	
	yield($Die, "finished")
	queue_free()


func _dieEffect():
	pass


func _processCollision(_collision : KinematicCollision2D):
	pass
