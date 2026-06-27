extends CharacterBody2D

enum enemy_state {
	PATROL,
	ALERT,
	RUSH,
	DYING,
	DEAD
}

var curr: enemy_state = enemy_state.PATROL 
const SPEED = 160.0
const JUMP_VELOCITY = -400.0
var dir = 1
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var patrol_limit : float = 200
var leftLimit
var rightLimit

func _ready():
	leftLimit = global_position.x - patrol_limit
	rightLimit = global_position.x + patrol_limit
	add_to_group("enemy")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	if curr == enemy_state.PATROL:
		if global_position.x > leftLimit and global_position.x < rightLimit: 
			velocity.x = dir * SPEED
		else:
			dir *= -1
			velocity.x = dir * SPEED
			global_position.x += dir * 2 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func enemy_dropped_on():
	curr = enemy_state.DYING
	collision_layer = 0
	collision_mask = 0
	collision_shape_2d.set_deferred("disabled", true)


func _on_kunai_entered(body: Node2D) -> void:
	print("YOO kunai entered my robo body")
	body.force_stick_to_moving_target(self)
	
