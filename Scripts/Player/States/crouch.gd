class_name Crouch
extends State

@onready var player : Player = $"../.."

#we'll change this later, we need a sprite for this, im just scaling it down which is goofy ash
func enter():
	print("Before crouch:", player.scale)
	player.scale = Vector2(0.665868, 0.381024) 
	player.sprite.play("Move")
	GlobalScript.curr_player_state = GlobalScript.PlayerStates.CROUCH

	
func physics_update(delta: float):
	var move_dir := player.get_x_input()
	if Input.is_action_just_released("crouch"):
		if move_dir == 0.0:
			transition("Idle")
		else:
			transition("Run")
	
	if Input.is_action_just_pressed("zip"):
		if player.can_zip_to_clingable():
			transition("Zip")
		return

	var target_x_velocity := move_dir * (player.max_speed/2)

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

func exit():
	player.scale = Vector2(1, 1) 
	print("after crouch:", player.scale)
