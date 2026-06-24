class_name Fall
extends State

@onready var player: Player = $"../.."

func enter():
	print("State = Fall")
	player.sprite.play("Move")
	player.movement_velocity.y = 0.0
	
func physics_update(delta: float):
	if player.grace_period > 0:
		player.grace_period -= delta
		
	if player.is_on_floor():
		transition("Idle")
		return
	elif player.grace_period > 0 and Input.is_action_pressed("jump"):
		transition("Jump")
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

		player.movement_velocity.y += player.gravity * delta * 1.5
		player.movement_velocity.y = min(
			player.movement_velocity.y,
			player.max_fall_speed
		)

		player.knockback_velocity = player.knockback_velocity.move_toward(
			Vector2.ZERO,
			player.knockback_decay * delta
		)
