class_name Run
extends State

@onready var player : Player = $"../.."

func enter():
	print("State = Run")
	player.sprite.play("Move")

func physics_update(delta: float):
	var move_dir := player.get_x_input()

	if !player.is_on_floor():
		transition("Fall")
		return
	elif Input.is_action_pressed("jump"):
		transition("Jump")
		return
	elif Input.is_action_pressed("crouch"):
		transition("Crouch")
		return
	elif move_dir == 0:
		transition("Idle")
		return
	elif Input.is_action_just_pressed("wall_cling"):
		transition("WallZip")
		return
	else:
		var target_x_velocity := move_dir * player.max_speed

		if player.movement_velocity.x * target_x_velocity < 0:
			player.movement_velocity.x = move_toward(
				player.movement_velocity.x,
				0.0,
				player.turn_deceleration * delta
			)

		player.movement_velocity.x = move_toward(
			player.movement_velocity.x,
			target_x_velocity,
			player.acceleration * delta
		)

		player.knockback_velocity = player.knockback_velocity.move_toward(
			Vector2.ZERO,
			player.knockback_decay * delta
		)
