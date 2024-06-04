class_name EnemyLogicState
extends StateMachine

var char_controller: CharacterController

func _init():
	super("Patrolling")
	add_state("Following")
	add_state("Attacking")

	add_transition("Patrolling", "Following")
	add_transition("Patrolling", "Attacking")

	add_transition("Following", "Patrolling")
	add_transition("Following", "Attacking")

	add_transition("Attacking", "Patrolling")
	add_transition("Attacking", "Following")

func _ready():
	pass

func _inject_char_controller(controller: CharacterController):
	char_controller = controller

func process_patrolling():
	pass

func process_following():
	pass

func process_attacking():
	pass

func process_state():
	# TODO: Implement logic to determine what the AI should be doing
	# TODO: Find a place to expose something for the input interface 
	#       get its input data from? i.e., if following then expose
	#       movement inputs to move in the right direction
	match current_state:
		"Patrolling":
			process_patrolling()
		"Following":
			process_following()
		"Attacking":
			process_attacking()
