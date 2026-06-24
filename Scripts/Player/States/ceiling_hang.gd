class_name CeilingHang
extends State

@onready var player: Player = $"../.."
@export var hang_time_max := 1.5  
@export var drop_sway_speed := 180.0
var hang_time := 0.0

func enter():
	print("State = CeilingHang")
	player.sprite.play("Idle")
	player.sprite.rotation = PI
	hang_time = hang_time_max

func physics_update(delta: float) -> void:
	hang_time -= delta

	if Input.is_action_just_pressed("wall_cling"):
		player.sprite.rotation = 0
		transition("WallZip")
		return

	if Input.is_action_pressed("crouch"):
		_drop_or_assassinate()
		return

	if hang_time <= 0:
		player.sprite.rotation = 0
		transition("Fall")
		return

func _drop_or_assassinate() -> void:
	player.sprite.rotation = 0
	var enemy := _find_enemy_below()
	if enemy != null:
		
		transition("Idle")
		return
	var move_dir := player.get_x_input()
	player.movement_velocity.x = move_dir * drop_sway_speed
	transition("Fall")

func _find_enemy_below() -> Node:
	var space_state := player.get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(
		player.global_position, player.global_position + Vector2.DOWN * 80
	)
	var result := space_state.intersect_ray(query)
	if result and result.collider.is_in_group("enemies"):
		return result.collider
	return null
