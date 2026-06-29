extends Node2D


func _on_retry_pressed() -> void:
		get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")

func _on_home_pressed() -> void:
		get_tree().change_scene_to_file("res://Scenes/Screens/main_menu.tscn")
	
