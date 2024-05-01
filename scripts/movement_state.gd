class_name MovementState
extends StateMachine

var input_interface : InputHandler

func _init(input_interface_inject : InputHandler):
	input_interface = input_interface_inject
	
	super("idle")
	add_state("moving")
	add_state("dash")

	add_transition("idle", "moving")
	add_transition("idle", "dash")
	add_transition("moving", "dash")
	add_transition("moving", "idle")
	add_transition("dash", "moving")
	add_transition("dash", "idle")