class_name Zip
extends State

@onready var player: Player = $"../.."

@export var zip_speed := 2200.0
@export var wall_offset := 6.0
var current_zip
var initial_point
var particle_offset : Vector2 = Vector2(0,-32)

var target_point: Vector2

func enter():
	print("State = Zip")

	player.movement_velocity = Vector2.ZERO 
	player.knockback_velocity = Vector2.ZERO

	target_point = player.zip_target_point
	player.wall_surface_normal = player.zip_surface_normal

	player.sprite.play("Idle")
	initial_point = player.global_position
	_spawn_dash_smoke()
	GlobalScript.curr_player_state = GlobalScript.PlayerStates.ZIP

	
	#var dash_instance = Particles.dash.instatiate()
	#dash_instance.global_position = player.global_position
	#get_tree().current_scene.add_child(dash_instance)
func physics_update(delta: float) -> void:
	var to_target := target_point - player.global_position

	if to_target == Vector2.ZERO:
		_finish_zip()
		return
	
	player.movement_velocity = to_target.normalized() * zip_speed
	player.knockback_velocity = Vector2.ZERO

	for i in player.get_slide_collision_count():
		var collision := player.get_slide_collision(i)
		var collider := collision.get_collider() as Node

		if collider != null and collider.is_in_group("clingable"):
			player.wall_surface_normal = collision.get_normal()
			_finish_zip()
			return

func find_target() -> bool:
	var dir := player.get_snapped_dir(player.get_mouse_dir())

	player.raycast.rotation = dir.angle()
	player.raycast.force_raycast_update()

	if not player.raycast.is_colliding():
		return false

	var body := player.raycast.get_collider() as Node

	if body == null or not body.is_in_group("clingable"):
		return false

	var hit_point := player.raycast.get_collision_point()
	var normal := player.raycast.get_collision_normal()

	player.wall_surface_normal = normal
	target_point = hit_point + normal * wall_offset

	return true

func _finish_zip() -> void:
	player.movement_velocity = Vector2.ZERO
	player.knockback_velocity = Vector2.ZERO

	if absf(player.wall_surface_normal.y) > 0.7:
		transition("CeilingHang")
	else:
		transition("WallCling")
func _spawn_zip():
	
	var zip = Particles.ZIP.instantiate() 
	zip.rotation = player.get_mouse_dir().angle()
	zip.global_position = initial_point - particle_offset
	get_tree().current_scene.add_child(zip)

	
func _spawn_dash_smoke() -> void:
	_spawn_zip()
	var smoke = Particles.SMOKE.instantiate()
	smoke.global_position = initial_point - particle_offset
	get_tree().current_scene.add_child(smoke)

	
