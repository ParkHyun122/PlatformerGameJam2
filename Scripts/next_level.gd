extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	match GlobalScript.current_level:
		GlobalScript.Levels.LEVEL_1:
			GlobalScript.current_level = GlobalScript.Levels.LEVEL_2
			get_tree().change_scene_to_file("res://Scenes/Levels/Level2.tscn")

		GlobalScript.Levels.LEVEL_2:
			GlobalScript.current_level = GlobalScript.Levels.LEVEL_3
			get_tree().change_scene_to_file("res://Scenes/Levels/Level3.tscn")

		GlobalScript.Levels.LEVEL_3:
			print("Game Complete")
