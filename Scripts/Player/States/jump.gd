class_name Jump
extends State

@onready var player: Player = $"../.."

func enter():
	print("State = Jump")
	player.grace_period = 0.0
	player.sprite.play("Move")
	player.movement_velocity.y = player.jump_velocity
	
func physics_update(delta: float):
	if player.velocity.y > 0 or player.is_on_ceiling():
		transition("Fall")
		return
	else:
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

		player.movement_velocity.y = min(
			player.movement_velocity.y,
			player.max_fall_speed
		)

		player.knockback_velocity = player.knockback_velocity.move_toward(
			Vector2.ZERO,
			player.knockback_decay * delta
		)
