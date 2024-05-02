class_name CombatState
extends StateMachine

var input_interface: InputHandler
var char_controller: CharacterController

func _init(input_interface_inject: InputHandler, char_controller_inject: CharacterController):
	input_interface = input_interface_inject
	char_controller = char_controller_inject

	super("Idle")
	add_state("Attacking")
	add_state("Blocking")
	add_state("Stagger")

	add_transition("Idle", "Attacking")
	add_transition("Attacking", "Idle")
	add_transition("Idle", "Blocking")
	add_transition("Blocking", "Idle")
	add_transition("Idle", "Stagger")
	add_transition("Stagger", "Idle")
	
	add_transition("Attacking", "Stagger")
	add_transition("Blocking", "Stagger")

# TODO: Create attack type class and make child classes?
#       LightAttack, HeavyAttack, AerialAttack inherit from AttackBase?

# TODO: Implement standard state functions

func can_attack() -> bool:
	if current_state != "Idle":
		return false
	return true

func process_idle():
	# Handle player input (?)
	var attack_input: bool = input_interface.get_attack_input()
	if attack_input and can_attack():
		# Call attack function(?)
		transition_state("Attacking")
	else:
		pass
	return

func process_attacking():
	return

func process_blocking():
	return

func process_stagger():
	return

func _on_state_transition(_previous_state: String, new_state: String):
	if new_state == "Idle":
		pass
	if new_state == "Attacking":
		pass
	if new_state == "Blocking":
		pass
	if new_state == "Stagger":
		pass
	return

func process_state():
	match current_state:
		"Idle":
			pass
		"Attacking":
			pass
		"Blocking":
			pass
		"Stagger":
			pass
	return