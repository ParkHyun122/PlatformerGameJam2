class_name Jump
extends State

@onready var player: Player = $"../.."

func enter():
	print("State = Jump")
	print("JUMP ENTERED")
	player.grace_period = 0.0
	player.sprite.play("Move")
	player.movement_velocity.y = player.jump_velocity
	GlobalScript.curr_player_state = GlobalScript.PlayerStates.JUMP

	
func physics_update(delta: float):
	if _check_clingable_collision():
		return

	if player.velocity.y > 0 or player.is_on_ceiling():
		transition("Fall")
		return
		
	if Input.is_action_just_pressed("zip"):
		if player.can_zip_to_clingable():
			transition("Zip")
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

	player.movement_velocity.y += player.gravity * delta
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
