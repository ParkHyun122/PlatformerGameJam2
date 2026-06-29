extends CharacterBody2D

@onready var flashlight: Flashlight = $Flashlight
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var warning: Sprite2D = $warning

@export var turn_pause := 1.0
@export var patrol_limit: float = 200.0

enum enemy_state {
	PATROL,
	ALERT,
	RUSH,
	DYING,
	DEAD
}

var curr: enemy_state = enemy_state.PATROL
const SPEED := 160.0

var dir := 1
var leftLimit: float
var rightLimit: float

var waiting_to_turn := false
var turn_timer := 0.0

func _ready() -> void:
	
	warning.visible = false

	flashlight.player_spotted.connect(_on_player_spotted)
	flashlight.player_escaped.connect(_on_player_escaped)

	leftLimit = global_position.x - patrol_limit
	rightLimit = global_position.x + patrol_limit
	add_to_group("enemy")
	update_flashlight_direction()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if waiting_to_turn:
		velocity.x = 0.0
		turn_timer -= delta

		if turn_timer <= 0.0:
			waiting_to_turn = false
			dir *= -1
			update_flashlight_direction()

	else:
		if curr == enemy_state.PATROL:
			if dir == 1 and global_position.x >= rightLimit:
				start_turn_wait()
			elif dir == -1 and global_position.x <= leftLimit:
				start_turn_wait()
			else:
				velocity.x = dir * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0.0, SPEED)
			

	move_and_slide()

func start_turn_wait() -> void:
	waiting_to_turn = true
	turn_timer = turn_pause
	velocity.x = 0.0

func update_flashlight_direction() -> void:
	flashlight.scale.x = dir

func enemy_dropped_on() -> void:
	queue_free()
	
func _on_player_spotted() -> void:
	warning.visible = true

func _on_player_escaped() -> void:
	warning.visible = false

func _on_player_caught() -> void:
	warning.visible = false
