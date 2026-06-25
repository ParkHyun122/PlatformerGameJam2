class_name Fall
extends State

@onready var player: Player = $"../.."

func enter():
	print("State = Fall")
	player.sprite.play("Move")
	player.movement_velocity.y = 0.0
	
func physics_update(delta: float):
	if _check_clingable_collision():
		return

	if player.grace_period > 0:
		player.grace_period -= delta
		
	if player.is_on_floor():
		transition("Idle")
		return

	if player.grace_period > 0 and Input.is_action_pressed("jump"):
		transition("Jump")
		return

	var move_dir := player.get_x_input()
	var target_x_velocity := move_dir * player.max_x_while_fall

	if move_dir != 0:
		player.movement_velocity.x = move_toward(
			player.movement_velocity.x,
			target_x_velocity,
			player.accel_x_while_fall * delta
		)
	else:
		player.movement_velocity.x = move_toward(
			player.movement_velocity.x,
			0.0,
			player.decel_x_while_fall * delta
		)

	player.movement_velocity.y += player.gravity * delta * 1.5
	player.movement_velocity.y = min(player.movement_velocity.y, player.max_fall_speed)

	player.knockback_velocity = player.knockback_velocity.move_toward(
		Vector2.ZERO,
		player.knockback_decay * delta
	)

func _check_clingable_collision() -> bool:
	if not player.can_attach_to_clingable():
		return false

	for i in player.get_slide_collision_count():
		var collision := player.get_slide_collision(i)
		var collider := collision.get_collider() as Node

		if collider != null and collider.is_in_group("clingable"):
			player.wall_surface_normal = collision.get_normal()
			player.movement_velocity = Vector2.ZERO
			player.knockback_velocity = Vector2.ZERO

			if absf(player.wall_surface_normal.y) > 0.7:
				transition("CeilingHang")
			else:
				transition("WallCling")

			return true

	return false
