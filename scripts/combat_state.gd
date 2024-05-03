class_name CombatState
extends StateMachine

var input_interface: InputHandler
var char_controller: CharacterController

func _init():

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

func _ready():
	return

func _inject_char_controller(controller: CharacterController):
	char_controller = controller
	return

func _inject_input_interface(interface: InputHandler):
	input_interface = interface
	return

func can_attack() -> bool:
	if current_state != "Idle":
		return false
	return true

func attack():
	var anim_player: AnimationPlayer = char_controller.get_node("CharacterCollisionShape/character_root/AnimationPlayer")
	anim_player.play("attack_light")
	return

func process_idle():
	var attack_input: bool = input_interface.get_attack_input()
	if attack_input and can_attack():
		attack()
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
			process_idle()
		"Attacking":
			process_attacking()
		"Blocking":
			process_blocking()
		"Stagger":
			process_stagger()
	return