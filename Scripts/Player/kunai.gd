class_name Kunai
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var SPEED = 300.0

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

func _physics_process(delta: float) -> void:
	if retrieving:
		dir = (player.global_position - global_position).angle()
		global_rotation = dir

		velocity = Vector2.RIGHT.rotated(dir) * SPEED
		move_and_slide()

		if global_position.distance_to(player.global_position) < 16:
			player.current_kunai = null
			queue_free()

		return

	if stuck:
		return

	velocity = Vector2.RIGHT.rotated(dir) * SPEED
	move_and_slide()

	if get_slide_collision_count() > 0:
		kunai_stuck()

func kunai_stuck():
	stuck = true
	velocity = Vector2.ZERO
	sprite.stop()
	
func retrieve():
	stuck = false
	retrieving = true
	sprite.play("Thrown")
func kunai_remove():
	queue_free()
