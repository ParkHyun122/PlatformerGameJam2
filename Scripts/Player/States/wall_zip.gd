class_name WallZip
extends State

@onready var player: Player = $"../.."
@export var zip_duration := 0.12

var target_point: Vector2
var tween: Tween

func enter():
	print("State = WallZip")
	player.movement_velocity = Vector2.ZERO
	player.knockback_velocity = Vector2.ZERO

	if not find_target():
		transition("Idle")
		return

	var dir := (target_point - player.global_position).normalized()
	player.sprite.rotation = dir.angle()
	player.sprite.play("Zip")

	tween = player.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(player, "global_position", target_point, zip_duration)
	tween.finished.connect(_on_zip_finished)

func physics_update(_delta: float) -> void:
	pass 

func find_target() -> bool:
	var dir := player.get_snapped_dir(player.get_mouse_dir())
	player.raycast.rotation = dir.angle()
	player.raycast.force_raycast_update()
	if not player.raycast.is_colliding():
		return false
	var body := player.raycast.get_collider() as Node
	if body == null or not body.is_in_group("platforms"):
		return false
	target_point = player.raycast.get_collision_point()
	player.wall_surface_normal = player.raycast.get_collision_normal()
	return true

func _on_zip_finished():
	player.sprite.rotation = 0
	if absf(player.wall_surface_normal.y) > 0.7:
		transition("CeilingHang")
	else:
		transition("WallCling")

func exit():
	if tween and tween.is_valid():
		tween.kill()
