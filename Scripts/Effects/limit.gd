class_name limit
extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer

func appear():
	anim.play("fade")
