class_name WallCling
extends State

@onready var player: Player = $"../.."
@export var hang_time_max := 0.8
@export var drop_sway_speed := 220.0
var hang_time := 0.0

func enter():
	print("State = WallCling")
	player.sprite.play("Idle")
	player.sprite.rotation = player.wall_surface_normal.angle() + PI / 2
	hang_time = hang_time_max

func physics_update(delta: float) -> void:
	hang_time -= delta

	if Input.is_action_just_pressed("wall_cling"):
		player.sprite.rotation = 0
		transition("WallZip")
		return

	if Input.is_action_pressed("jump"):
		player.sprite.rotation = 0
		if player.wall_surface_normal.y > 0.5:
			transition("Fall")
			return
		player.movement_velocity.x = player.wall_surface_normal.x * player.wall_jump_x_velocity
		player.movement_velocity.y = player.jump_velocity
		transition("Jump")
		return

	if Input.is_action_pressed("crouch"):
		_deliberate_drop()
		return

	if hang_time <= 0:
		player.sprite.rotation = 0
		player.grace_period = 0.0
		transition("Fall") # forced — should feel like a slip, not a choice
		return

func _deliberate_drop():
	player.sprite.rotation = 0
	player.grace_period = 0.0
	var move_dir := player.get_x_input()
	player.movement_velocity.x = move_dir * drop_sway_speed
	transition("Fall")
