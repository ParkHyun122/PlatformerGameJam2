class_name Smoke
extends Node2D

@onready var anim : AnimationPlayer = $AnimationPlayer

func _ready():
	anim.play("smoke")
