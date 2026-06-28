class_name Player
extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast : RayCast2D = $CollisionShape2D/WallDetector
@onready var main = get_tree().current_scene
@onready var kunai = preload("res://Scenes/Player/kunai.tscn")
var drop_target_enemy: Node2D = null
@onready var label: Label = $UI/Label
@onready var zip_limit: limit = $limit

@export var max_speed := 200.0
@export var acceleration := 1200.0
@export var deceleration := 3000.0
@export var turn_deceleration := 4500.0
@export var knockback_decay := 900.0
@export var gravity := 1200.0
@export var max_fall_speed := 800.0
@export var max_x_while_fall := 100.0
@export var accel_x_while_fall := 1200.0
@export var decel_x_while_fall := 1800.0
@export var jump_velocity := -2000.0
@export var fall_grace_period := 0.2
@export var zip_range := 300
@export var wall_jump_x_velocity := 300.0
@export var cling_check_distance := 24.0
@export var cling_detach_lockout_max := 0.2
@export var ceiling_detach_lockout_max := 0.2
@export var afterimage_scene: PackedScene
@export var afterimage_interval := 0.04

var afterimage_timer := 0.0
var ceiling_detach_lockout := 0.0
var cling_detach_lockout := 0.0
var grace_period := 0.0
var movement_velocity := Vector2.ZERO
var knockback_velocity := Vector2.ZERO
var wall_surface_normal := Vector2.ZERO
var current_kunai : Kunai 

const N_DIAG = 0.707107

const EIGHT_DIRS := [
	Vector2.RIGHT, Vector2(N_DIAG, N_DIAG), Vector2.DOWN, Vector2(-N_DIAG, N_DIAG),
	Vector2.LEFT, Vector2(-N_DIAG, -N_DIAG), Vector2.UP, Vector2(N_DIAG, -N_DIAG)
]

func get_snapped_dir(raw_dir: Vector2) -> Vector2:
	var best_dir := EIGHT_DIRS[0]
	var best_dot := -INF
	for d in EIGHT_DIRS:
		var dot := raw_dir.dot(d)
		if dot > best_dot:
			best_dot = dot
			best_dir = d
	return best_dir

# call every physics frame from a state OTHER than Zip/WallCling/CeilingHang
func update_zip_trace(trace: Line2D) -> void:
	var dir := get_snapped_dir(get_mouse_dir())
	raycast.rotation = dir.angle()
	raycast.force_raycast_update()
	if raycast.is_colliding():
		trace.default_color = Color.GREEN if (raycast.get_collider() as Node).is_in_group("platforms") else Color.RED
		trace.points = [Vector2.ZERO, to_local(raycast.get_collision_point())]
	else:
		trace.default_color = Color.RED
		trace.points = [Vector2.ZERO, dir * zip_range]
func _ready() -> void:
	zip_limit.visible = false;
	raycast.target_position.x = zip_range
	add_to_group("player")

func _physics_process(delta: float) -> void:
	
	if ceiling_detach_lockout > 0.0:
		ceiling_detach_lockout -= delta
		
	if Input.is_action_just_pressed("throw_kunai"):
		throw_or_retrieve_kunai()
		
	if cling_detach_lockout > 0.0:
		cling_detach_lockout -= delta
	
	var face_dir = get_x_input()

	if face_dir == -1.0:
		sprite.flip_h = true
	elif face_dir == 1.0:
		sprite.flip_h = false
	queue_redraw()
	velocity = movement_velocity + knockback_velocity
	move_and_slide()

var last_x_dir := 1.0

func get_x_input() -> float:
	var left := Input.is_action_pressed("left")
	var right := Input.is_action_pressed("right")

	if left and right:
		return last_x_dir

	if left:
		last_x_dir = -1.0
		return -1.0

	if right:
		last_x_dir = 1.0
		return 1.0

	return 0.0

func throw_or_retrieve_kunai():
	if current_kunai == null:
		current_kunai = kunai.instantiate()
		current_kunai.player = self
		current_kunai.dir = get_mouse_dir().angle()
		current_kunai.spawnPos = global_position
		current_kunai.spawnRot = get_mouse_dir().angle()
		main.add_child.call_deferred(current_kunai)
	else:
		current_kunai.retrieve()
		
func get_mouse_dir() -> Vector2 :
	return (get_global_mouse_position() - global_position).normalized()
	
var zip_target_point := Vector2.ZERO
var zip_surface_normal := Vector2.ZERO

func can_zip_to_clingable() -> bool:
	var dir := get_snapped_dir(get_mouse_dir())

	raycast.rotation = dir.angle()
	raycast.force_raycast_update()
	var ray_tip := raycast.to_global(raycast.target_position)

	if not raycast.is_colliding():
		zip_limit.global_position = ray_tip
		zip_limit.rotation = dir.angle()
		zip_limit.appear()
		return false

	var body := raycast.get_collider() as Node
	if body == null or not body.is_in_group("clingable"):
		zip_limit.global_position = ray_tip
		zip_limit.rotation = dir.angle()
		zip_limit.appear()
		return false

	var hit_point := raycast.get_collision_point()
	var normal := raycast.get_collision_normal()

	zip_surface_normal = normal
	zip_target_point = hit_point + normal * 6.0

	return true
	
func start_cling_detach_lockout() -> void:
	cling_detach_lockout = cling_detach_lockout_max

func can_attach_to_clingable() -> bool:
	return cling_detach_lockout <= 0.0

func _draw() -> void:

	if GlobalScript.curr_player_state == GlobalScript.PlayerStates.CELINGHANG:

		return

	if can_zip_to_clingable():

		var from_pos = Vector2.ZERO

		var to_pos = to_local(zip_target_point)

		var line_color = Color.DARK_CYAN

		var line_width = 3.0

		var dash_length = 8.0

		draw_dashed_line(from_pos, to_pos, line_color, line_width, dash_length)
		
func get_caught() -> void:
	print("PLAYER CAUGHT")
	# temporary death logic
	queue_free()

func start_ceiling_detach_lockout() -> void:
	ceiling_detach_lockout = ceiling_detach_lockout_max

func can_attach_to_ceiling() -> bool:
	return ceiling_detach_lockout <= 0.0
	
func spawn_afterimage() -> void:
	var ghost := afterimage_scene.instantiate() as Sprite2D
	main.add_child(ghost)

	ghost.global_position = sprite.global_position
	ghost.global_rotation = sprite.global_rotation
	ghost.global_scale = sprite.global_scale
	ghost.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	ghost.flip_h = sprite.flip_h
	ghost.modulate = Color(1, 1, 1, 0.45)

	ghost.start()
