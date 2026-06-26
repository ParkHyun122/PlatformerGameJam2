class_name Kunai
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var throw_speed = 2000.0
@export var retrieve_speed = 2000.0

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
		print("retrieving")
		dir = (player.global_position - global_position).angle()
		global_rotation = dir

		velocity = Vector2.RIGHT.rotated(dir) * retrieve_speed
		move_and_slide()

		if global_position.distance_to(player.global_position) < 20:
			player.current_kunai = null
			queue_free()

		return

	if stuck:
		print("stuck")
		return

	print("throwing")
	velocity = Vector2.RIGHT.rotated(dir) * throw_speed
	move_and_slide()

	if get_slide_collision_count() > 0:
		kunai_stuck()

<<<<<<< Updated upstream
func kunai_stuck():
	stuck = true
	velocity = Vector2.ZERO
	sprite.stop()
	
func retrieve():
	stuck = false
	retrieving = true
	sprite.play("Thrown")
=======
func kunai_remove():
	queue_free()
>>>>>>> Stashed changes
