extends Sprite2D

@export var fade_time := 0.25

func start() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_time)
	tween.finished.connect(queue_free)
