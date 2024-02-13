class_name Finite_state_machine
extends Node

@export var state : State


func _ready():
	change_state(state)
	
	


func change_state(new_state: State):
	if state is State:
		if new_state != state:
			state.exit_state()
			new_state.enter_state()
			state = new_state
 
func _process(delta):
	$"../Label3D".text = str(state)
	state.update()
