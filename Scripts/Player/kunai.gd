class_name Kunai
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var SPEED = 300.0

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready() -> void:
	sprite.play("Thrown")
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(dir) * SPEED
	move_and_slide()

	if get_slide_collision_count() > 0:
		kunai_remove()
		

func kunai_remove():
	#this somehow crashes my game
	#get_tree().add_child()
	queue_free()
