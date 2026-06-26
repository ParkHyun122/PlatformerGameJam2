class_name DropAttack
extends State


@onready var player: Player = $"../.."

@export var snap_offset := Vector2(0, -10) 

var target_enemy: Node2D

func enter():
	print("State = DropAttack")
	target_enemy = player.drop_target_enemy

	if target_enemy == null or not is_instance_valid(target_enemy):
		transition("Fall")
		return

	# snap onto him instead of resolving wherever physics happened to leave you
	player.global_position = target_enemy.global_position + snap_offset
	player.movement_velocity = Vector2.ZERO
	player.knockback_velocity = Vector2.ZERO
	player.velocity = Vector2.ZERO
	player.label.text = ""

	player.sprite.play("Assassinate")
	_on_animation_finished()

	#if not player.sprite.animation_finished.is_connected(_on_animation_finished):
		#player.sprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)

func physics_update(delta: float) -> void:
	player.movement_velocity = Vector2.ZERO # hold still through the kill anim

func _on_animation_finished():
	if is_instance_valid(target_enemy) and target_enemy.has_method("enemy_dropped_on"):
		target_enemy.enemy_dropped_on()

	player.drop_target_enemy = null
	transition("Fall")
