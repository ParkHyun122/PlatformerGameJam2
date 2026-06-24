class_name Idle
extends State

@onready var player : Player = $"../.."
@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"

func enter():
	print("State = Idle")
	sprite.play("Idle")
	player.grace_period = player.fall_grace_period
	player.movement_velocity.y = 0

func physics_update(delta: float):
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transition("Run")
		return
	elif Input.is_action_pressed("jump"):
		transition("Jump")
		return
	elif Input.is_action_pressed("crouch"):
		transition("Crouch")
		return
	elif !player.is_on_floor():
		transition("Fall")
		return
	elif Input.is_action_pressed("wall_cling"):
		transition("WallCling")
		return
	else:
		player.movement_velocity = player.movement_velocity.move_toward(Vector2.ZERO, player.deceleration * delta)
		player.knockback_velocity = player.knockback_velocity.move_toward(Vector2.ZERO, player.knockback_decay * delta)
