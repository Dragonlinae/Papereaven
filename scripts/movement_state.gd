class_name MovementState
extends StateMachine

func _init():
	super("still_ground")
	add_state("moving_ground")
	add_state("dash")

	add_transition("still_ground", "moving_ground")
	add_transition("still_ground", "dash")
	add_transition("moving_ground", "dash")
	add_transition("moving_Ground", "still_ground")
	add_transition("dash", "moving_ground")
	add_transition("dash", "still_ground")