extends Node2D



@onready var door1: TileMapLayer = $map/Layer2

@onready var player: Player = $Player

var door_speed: float = 200.0

  

var is_door_hit: bool = false

var door_target_y



func _ready() -> void:
	GlobalScript.current_level = GlobalScript.Levels.LEVEL_2
	if door1:
		door_target_y = door1.global_position.y - 512
	 
func door_hit():
	is_door_hit = true


func _process(delta: float) -> void:
	if not door1: return
	if is_door_hit:
		door1.global_position.y = move_toward(door1.global_position.y, door_target_y, door_speed * delta)
	if door1.global_position.y <= door_target_y:
		is_door_hit = false

func _on_body_entered(body: Node2D) -> void:
	print("Ive been hit by the kunai")
	if body.is_in_group("kunai"):
		
		if body.has_method("force_stuck"):
			body.force_stuck()
			var rootnode = get_tree().current_scene
			if rootnode.has_method("door_hit"):
				rootnode.door_hit()
