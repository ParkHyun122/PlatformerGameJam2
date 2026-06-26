class_name DropAttack
extends State


@onready var player: Player = $"../.."

var target_enemy: Node2D = null
var is_assassinating := false

func enter():
	print("State = DropAttack")
	is_assassinating = false
	target_enemy = player.current_drop_target
	
	player.sprite.play("Fall") 

	player.movement_velocity = Vector2.ZERO
	player.knockback_velocity = Vector2.ZERO

func physics_update(delta: float):
	if target_enemy == null or not is_instance_valid(target_enemy):
		transition("Fall")
		return

	var distance_to_enemy = player.global_position.distance_to(target_enemy.global_position)

	if distance_to_enemy < 40.0 and not is_assassinating:
		_start_assassination_snap()

	if is_assassinating and Input.is_action_just_pressed("left_mouse"):
		_execute_kill()

func _start_assassination_snap():
	is_assassinating = true
	
	# Disable player collision layers/masks so they phase through the enemy completely
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(3, false)
	
	player.sprite.play("Attack") 
	player.label.text = "[LMB] to Execute Enemy!"

	# Smoothly snap player's position slightly above the enemy's centerpoint
	var target_pos = target_enemy.global_position + Vector2.UP * 16
	var tween = create_tween().set_parallel(false)
	tween.tween_property(player, "global_position", target_pos, 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _execute_kill():
	if target_enemy.has_method("enemy_dropped_on"):
		target_enemy.enemy_dropped_on() # Triggers death inside enemy script
	
	player.label.text = ""
	
	# Restore physics layers before changing states
	player.set_collision_layer_value(1, true)
	player.set_collision_mask_value(1, true)
	
	transition("Idle")
