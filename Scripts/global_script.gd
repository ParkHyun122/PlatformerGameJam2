extends Node

enum PlayerStates {
	IDLE,
	RUN,
	JUMP,
	CROUCH,
	FALL,
	WALLCLING,
	ZIP,
	CELINGHANG,
	DROPATTACK
}

var curr_player_state : PlayerStates

func _ready() -> void:
	pass # Replace with function body.
	curr_player_state = PlayerStates.IDLE
