class_name WallCling
extends State

@onready var player: Player = $"../.."

var surface_slope
var cling_point
var clinged_on := false
var hang_time := 2.0

func enter():
	print("State = WallCling")
	player.sprite.play("Idle")
	#add vfx that makes it look like a dash
	try_cling()
	
func physics_update(delta: float):
	#it should take some time to get to the other side cuz its technically "dashing,
	#although it is implemented as teleportation
	
	#clings on!
	if clinged_on == false:
		player.position = cling_point
		player.sprite.rotation = surface_slope.angle() + PI / 2
		clinged_on = true;

	if clinged_on and hang_time > 0:
		hang_time -= delta
		
	if Input.is_action_just_pressed("wall_cling"):
		player.sprite.rotation = 0
		try_cling()
		return
		
	if Input.is_action_pressed("jump"):
		player.sprite.rotation = 0
		if surface_slope.y > 0.5:
			# ceiling: no wall jump
			transition("Fall")
			return

		player.movement_velocity.x = surface_slope.x * player.wall_jump_x_velocity
		player.movement_velocity.y = player.jump_velocity
		transition("Jump")
		return
		
	if (hang_time <= 0 or Input.is_action_pressed("crouch") 
		or Input.is_action_pressed("left") 
		or Input.is_action_pressed("right")):
		player.sprite.rotation = 0
		player.grace_period = 0.0
		transition("Fall")
		return

func try_cling():
	hang_time = 0.7
	clinged_on = false

	var dir := (player.get_global_mouse_position() - player.global_position).normalized()

	player.raycast.rotation = dir.angle()
	player.raycast.force_raycast_update()

	if not player.raycast.is_colliding():
		#make visual feedback to the players in ui layer so they know that theyre out of range
		print("no platforms to cling on!")
		transition("Idle")
		return

	var body := player.raycast.get_collider() as Node
	if body == null or not body.is_in_group("platforms"):
		transition("Idle")
		return
	
	player.movement_velocity = Vector2.ZERO
	cling_point = player.raycast.get_collision_point()
	surface_slope = player.raycast.get_collision_normal()
