class_name CeilingHang
extends State

@onready var player: Player = $"../.."

@export var cling_move_speed := 200.0
@export var drop_sway_speed := 180.0

var just_entered := false

func enter():
	print("State = CeilingHang")
	player.sprite.play("Idle")
	player.movement_velocity = Vector2.ZERO
	player.knockback_velocity = Vector2.ZERO
	just_entered = true

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("zip"):
		if player.can_zip_to_clingable():
			transition("Zip")
		return

	if Input.is_action_pressed("crouch"):
		_drop_or_assassinate()
		return

	if just_entered:
		just_entered = false
	else:
		if not _still_touching_clingable():
			transition("Fall")
			return

	_move_along_ceiling()

func _move_along_ceiling() -> void:
	var input_x := player.get_x_input()

	player.movement_velocity = Vector2.RIGHT * input_x * cling_move_speed
	player.knockback_velocity = Vector2.ZERO

func _drop_or_assassinate() -> void:
	var enemy := _find_enemy_below()

	if enemy != null:
		transition("Idle")
		return

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

func _find_enemy_below() -> Node:
	var space_state := player.get_world_2d().direct_space_state

	var query := PhysicsRayQueryParameters2D.create(
		player.global_position,
		player.global_position + Vector2.DOWN * 80
	)
	query.exclude = [player]

	var result := space_state.intersect_ray(query)

	if result.is_empty():
		return null

	var collider := result["collider"] as Node

	if collider != null and collider.is_in_group("enemies"):
		return collider

	return null
