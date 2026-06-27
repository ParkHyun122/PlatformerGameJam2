extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("button")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("trigger"):
		print("Ive been hit by the kunai")
		if body.has_method("force_stuck"):
			body.force_stuck()
			var rootnode = get_tree().current_scene 
			if rootnode.has_method("door_hit"):
				rootnode.door_hit()
