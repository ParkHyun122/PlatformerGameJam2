class_name WallCling
extends State

@onready var player: Player = $"../.."

@export var cling_move_speed := 500.0
@export var drop_sway_speed := 220.0

var just_entered := false

func enter():
	print("State = WallCling")
	player.sprite.play("Idle")
	player.movement_velocity = Vector2.ZERO
	player.knockback_velocity = Vector2.ZERO
	just_entered = true

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("zip"):
		if player.can_zip_to_clingable():
			transition("Zip")
		return

	if Input.is_action_just_pressed("jump"):
		_wall_jump()
		return

	if Input.is_action_pressed("crouch"):
		_deliberate_drop()
		return

	if just_entered:
		just_entered = false
	else:
		if not _still_touching_clingable():
			transition("Fall")
			return

	_move_along_wall()

func _move_along_wall() -> void:
	var input_x := player.get_x_input()

	var tangent := Vector2(-player.wall_surface_normal.y, player.wall_surface_normal.x)

	var along_wall := tangent * input_x * cling_move_speed
	var into_wall := -player.wall_surface_normal * 30.0

	player.movement_velocity = along_wall + into_wall
	player.knockback_velocity = Vector2.ZERO

func _wall_jump() -> void:
	player.start_cling_detach_lockout()

	player.movement_velocity.x = player.wall_surface_normal.x * player.wall_jump_x_velocity
	player.movement_velocity.y = player.jump_velocity
	transition("Jump")

func _deliberate_drop() -> void:
	player.grace_period = 0.0
	player.start_cling_detach_lockout()

	var move_dir := player.get_x_input()
	player.movement_velocity.x = move_dir * drop_sway_speed
	transition("Fall")

func _still_touching_clingable() -> bool:
	for i in player.get_slide_collision_count():
		var collision := player.get_slide_collision(i)
		var collider := collision.get_collider() as Node

		if collider != null and collider.is_in_group("clingable"):
			player.wall_surface_normal = collision.get_normal()
			return true

	return false
