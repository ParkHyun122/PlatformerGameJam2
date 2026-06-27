extends Node2D
@onready var map: Node2D = $map
@onready var door1: TileMapLayer = $map/Layer2
@onready var player: Player = $Player
var door_speed: float = 200.0 

var is_door_hit: bool = false
var door_target_y

# Called when the node enters the scene tree for the firdst time.
func _ready() -> void:
	door_target_y = door1.global_position.y - 512

func door_hit():
	is_door_hit = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_door_hit:
		door1.global_position.y = move_toward(door1.global_position.y, door_target_y, door_speed * delta)
		
		if door1.global_position.y <= door_target_y:
			is_door_hit = false 
