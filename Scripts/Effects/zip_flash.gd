class_name Zip_flash
extends Node2D

@onready var anim : AnimationPlayer = $AnimationPlayer

func _ready():
	anim.play("zip_flash")
