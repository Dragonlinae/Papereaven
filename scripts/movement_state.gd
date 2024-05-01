class_name MovementState
extends StateMachine

var input_interface : InputHandler
var char_controller : CharacterController

func _init(input_interface_inject : InputHandler, char_controller_inject : CharacterController):
	input_interface = input_interface_inject
	char_controller = char_controller_inject

	print(input_interface)
	print(char_controller)

	super("Idle")
	add_state("Moving")
	add_state("Dash")

	add_transition("Idle", "Moving")
	add_transition("Idle", "Dash")
	add_transition("Moving", "Dash")
	add_transition("Moving", "Idle")
	add_transition("Dash", "Moving")
	add_transition("Dash", "Idle")

func handle_jump():
	var jump_input : bool = input_interface.get_jump_input()
	if jump_input and char_controller.is_on_floor():
		char_controller.jump()

func process_idle():
	var movement_direction : float = input_interface.get_movement_direction()
	if movement_direction:
		transition_state("Moving")
	elif false:
		transition_state("Dash")
	else:
		handle_jump()
		char_controller.velocity.x = 0
	return

func process_moving():
	var movement_direction : float = input_interface.get_movement_direction()
	if movement_direction:
		# TODO: Add checks for stun or anything that might prevent the character from moving
		handle_jump()
		char_controller.velocity.x = movement_direction * char_controller.move_velocity
	else:
		transition_state("Idle")
	return

func process_dash():
	assert(false, "Called an unimplemented function")
	return

func _on_state_transition(_previous_state : String, new_state : String):
	if new_state == "Idle":
		process_idle()
	elif new_state == "Moving":
		process_moving()
	elif new_state == "Dash":
		process_dash()
	else:
		assert(false, "Unreachable state")
	return

func process_state():
	match current_state:
		"Idle":
			process_idle()
		"Moving":
			process_moving()
		"Dash":
			process_dash()