class_name Kunai
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var throw_speed = 2000.0
@export var retrieval_speed = 2200.0

var player : Player
var dir : float
var spawnPos : Vector2
var spawnRot : float
var stuck := false
var retrieving := false
func _ready() -> void:
	sprite.play("Thrown")
	global_position = spawnPos
	global_rotation = spawnRot
	add_collision_exception_with(player)

func _physics_process(delta: float) -> void:
	if retrieving:
		dir = (player.global_position - global_position).angle()
		global_rotation = dir

		velocity = Vector2.RIGHT.rotated(dir) * retrieval_speed
		move_and_slide()

		if global_position.distance_to(player.global_position) < 25:
			player.current_kunai = null
			queue_free()
		return

	if stuck:
		return

	velocity = Vector2.RIGHT.rotated(dir) * throw_speed
	move_and_slide()

	if get_slide_collision_count() > 0:
		kunai_stuck()

func kunai_stuck():
	stuck = true
	velocity = Vector2.ZERO
	sprite.stop()
	_spawn_hit_fx()

func _spawn_hit_fx() -> void:
	var fx = Particles.KUNAI_WALL.instantiate()
	fx.global_position = global_position
	fx.rotation = global_rotation
	get_tree().current_scene.add_child(fx)
	
func retrieve():
	stuck = false
	retrieving = true
	sprite.play("Thrown")
func kunai_remove():
	queue_free()
