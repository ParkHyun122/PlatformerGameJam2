class_name Flashlight
extends Area2D

signal player_spotted
signal player_escaped

@export var catch_delay := 1.5

var target_player: Player = null
var catch_timer := 0.0
@onready var visual: Polygon2D = $Polygon2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	if target_player == null:
		return

	if not is_instance_valid(target_player):
		target_player = null
		player_escaped.emit()
		return

	catch_timer -= delta

	if catch_timer <= 0.0:
		target_player.get_caught()
		target_player = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target_player = body
		catch_timer = catch_delay
		visual.modulate.a8 = 250
		print("PLAYER SPOTTED")
		player_spotted.emit()

func _on_body_exited(body: Node2D) -> void:
	if body == target_player:
		target_player = null
		visual.modulate.a8 = 83
		catch_timer = 0.0
		player_escaped.emit()
		print("PLAYER ESCAPED")
