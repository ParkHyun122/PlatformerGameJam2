extends Area2D

  
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var can_press = true

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:

	add_to_group("button")
	animation_player.play("init")

  


func _process(delta: float) -> void:

	pass

  

  

func _on_body_entered(body: Node2D) -> void:
	if not can_press : return
	animation_player.play("pressing")
	audio_stream_player.playing = true
	if body.is_in_group("trigger"):
		print("Ive been hit by the kunai")
	if body.has_method("force_stuck"):
		body.force_stuck()
		var rootnode = get_tree().current_scene
		if rootnode.has_method("door_hit"):
			rootnode.door_hit()

	can_press = false


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "pressing":
		animation_player.play("pressed")
