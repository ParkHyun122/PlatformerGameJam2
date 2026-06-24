class_name Player
extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast : RayCast2D = $CollisionShape2D/WallDetector

@export var max_speed := 300.0
@export var acceleration := 1200.0
@export var deceleration := 3000.0
@export var turn_deceleration := 4500.0
@export var knockback_decay := 900.0
@export var gravity := 1200.0
@export var max_fall_speed := 800.0
@export var max_x_while_fall := 100.0
@export var accel_x_while_fall := 1200.0
@export var decel_x_while_fall := 1800.0
@export var jump_velocity := -2000.0
@export var fall_grace_period := 0.2
@export var wall_cling_range := 300
@export var wall_jump_x_velocity := 300.0

var grace_period := 0.0
var movement_velocity := Vector2.ZERO
var knockback_velocity := Vector2.ZERO

func _ready() -> void:
	raycast.target_position.x = wall_cling_range

func _physics_process(delta: float) -> void:
	var face_dir = get_x_input()

	if face_dir == -1.0:
		sprite.flip_h = true
	elif face_dir == 1.0:
		sprite.flip_h = false

	velocity = movement_velocity + knockback_velocity
	move_and_slide()

var last_x_dir := 1.0

func get_x_input() -> float:
	var left := Input.is_action_pressed("left")
	var right := Input.is_action_pressed("right")

	if left and right:
		return last_x_dir

	if left:
		last_x_dir = -1.0
		return -1.0

	if right:
		last_x_dir = 1.0
		return 1.0

	return 0.0
