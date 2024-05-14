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
	pass

func _inject_char_controller(controller: CharacterController):
	char_controller = controller
	char_controller.animation_changed_signal.connect(on_anim_changing)

func _inject_input_interface(interface: InputHandler):
	input_interface = interface

func can_attack() -> bool:
	if current_state != "Idle":
		return false
	return true

func attack():
	transition_state("Attacking")
	char_controller.play_animation("attack_light")

func attack_heavy():
	transition_state("Attacking")
	char_controller.play_animation("attack_heavy")

func on_attack_end():
	# TODO: Think about what would happen if attack gets interrupted -> stagger
	# print("Attack ended!")
	transition_state("Idle")

func can_block() -> bool:
	if current_state != "Idle":
		return false
	return true

func block():
	print("In Block()")
	transition_state("Blocking")
	char_controller.play_animation("block")
	pass

func on_block_end():
	# TODO: Think about what would happen if an attack pierces block -> stagger
	transition_state("Idle")

func process_idle():
	var attack_input: bool = input_interface.get_attack_input()
	var attack_heavy_input: bool = input_interface.get_attack_heavy_input()
	var block_input: bool = input_interface.get_block_input()
	if attack_heavy_input and can_attack():
		print("Calling heavy attack()")
		attack_heavy()
	elif attack_input and can_attack():
		print("Calling attack()")
		attack()
	elif block_input and can_block():
		print("Calling block()")
		block()
	else:
		pass

func process_attacking():
	pass

func process_blocking():
	pass

func process_stagger():
	pass

func _on_state_transition(_previous_state: String, new_state: String):
	if new_state == "Idle":
		pass
	if new_state == "Attacking":
		pass
	if new_state == "Blocking":
		pass
	if new_state == "Stagger":
		pass

func on_anim_changing(animationName: String):
	print(animationName, " was played.")

func process_state():
	if Input.is_action_pressed("debug_print"):
		print(current_state)
		pass
	match current_state:
		"Idle":
			process_idle()
		"Attacking":
			process_attacking()
		"Blocking":
			process_blocking()
		"Stagger":
			process_stagger()
