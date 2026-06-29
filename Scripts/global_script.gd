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

enum Levels {
	LEVEL_1,
	LEVEL_2,
	LEVEL_3
}

var curr_player_state : PlayerStates
var current_level : Levels

func _ready() -> void:
	curr_player_state = PlayerStates.IDLE
	current_level = Levels.LEVEL_1
