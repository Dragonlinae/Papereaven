class_name MovementState
extends StateMachine

var input_interface : InputHandler
var char_controller : CharacterController

func _init(input_interface_inject : InputHandler, char_controller_inject : CharacterController):
	input_interface = input_interface_inject
	char_controller = char_controller_inject

	print(input_interface)
	print(char_controller)

	super("idle")
	add_state("moving")
	add_state("dash")

	add_transition("idle", "moving")
	add_transition("idle", "dash")
	add_transition("moving", "dash")
	add_transition("moving", "idle")
	add_transition("dash", "moving")
	add_transition("dash", "idle")

func handle_jump():
	var jump_input : bool = input_interface.get_jump_input()
	if jump_input and char_controller.is_on_floor():
		char_controller.jump()

func process_idle():
	var movement_direction : float = input_interface.get_movement_direction()
	if movement_direction:
		transition_state("moving")
	elif false:
		transition_state("dash")
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
		transition_state("idle")
	return

func process_dash():
	assert(false, "Called an unimplemented function")
	return

func _on_state_transition(_previous_state : String, new_state : String):
	if new_state == "idle":
		process_idle()
	elif new_state == "moving":
		process_moving()
	elif new_state == "dash":
		process_dash()
	else:
		assert(false, "Unreachable state")
	return

func process_state():
	match current_state:
		"idle":
			process_idle()
		"moving":
			process_moving()
		"dash":
			process_dash()