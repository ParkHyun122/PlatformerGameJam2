class_name DropAttack
extends State

@onready var player: Player = $"../.."

@export var snap_offset := Vector2.ZERO
@export var drop_speed := 1200.0
@export var kill_enable_delay := 0.08

var target_enemy: Node2D
var target_location: Vector2
var has_killed := false
var kill_timer := 0.0

func enter():
	print("State = DropAttack")
	GlobalScript.curr_player_state = GlobalScript.PlayerStates.DROPATTACK

	target_enemy = player.drop_target_enemy
	has_killed = false
	kill_timer = kill_enable_delay

	if target_enemy == null or not is_instance_valid(target_enemy):
		transition("Idle")
		return

	player.knockback_velocity = Vector2.ZERO
	player.movement_velocity = Vector2.ZERO
	player.velocity = Vector2.ZERO
	player.label.text = ""

	player.sprite.play("Fall")

func physics_update(delta: float) -> void:
	if target_enemy == null or not is_instance_valid(target_enemy):
		player.movement_velocity = Vector2.ZERO
		player.drop_target_enemy = null
		transition("Idle")
		return

	target_location = target_enemy.global_position + snap_offset
	var to_target := target_location - player.global_position

	player.movement_velocity = to_target.normalized() * drop_speed
	player.knockback_velocity = Vector2.ZERO

	kill_timer -= delta

	if kill_timer <= 0.0:
		for i in player.get_slide_collision_count():
			var collision := player.get_slide_collision(i)
			var collider := collision.get_collider()

			if collider == target_enemy:
				print("true?:",collider == target_enemy )
				perform_kill()
				return

func perform_kill() -> void:
	if has_killed:
		return

	has_killed = true

	player.movement_velocity = Vector2.ZERO
	player.knockback_velocity = Vector2.ZERO
	player.sprite.play("Assassinate")

	if is_instance_valid(target_enemy) and target_enemy.has_method("enemy_dropped_on"):
		target_enemy.enemy_dropped_on()

	player.drop_target_enemy = null

	if player.is_on_floor():
		transition("Idle")
	else:
		transition("Fall")
