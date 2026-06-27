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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_player_state = PlayerStates.IDLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
