class_name EnemyLogicState
extends StateMachine

@export var enemy_input_handler: EnemyInputHandler

@export var close_distance: float = 125
@export var far_distance: float = 175

var distance_to_player: float
var player_x: float
var enemy_x: float

var char_controller: CharacterController

func _init():
	super("Following")
	add_state("Patrolling")
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
	print("Patrolling")
	if distance_to_player < 1500:
		transition_state("Following")
	pass

func process_following():
	if distance_to_player >= 1500:
		transition_state("Patrolling")
	if distance_to_player <= far_distance:
		print("Going to attacking phase")
		transition_state("Attacking")
	pass

func process_attacking():
	if distance_to_player >= far_distance:
		print("Going to following phase")
		transition_state("Following")
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

func _process(_delta):

	var root_node: Node = get_tree().get_root() as Node
	var scene_root: Node2D = root_node.get_node("Node2D") as Node2D
	var player: CharacterController = scene_root.get_node("Player") as CharacterController
	var enemy: CharacterController = get_parent().get_parent() as CharacterController

	if enemy == null:
			return 0

	var player_collision_shape: CollisionShape2D = player.get_node("CharacterCollisionShape") as CollisionShape2D
	var enemy_collision_shape: CollisionShape2D = enemy.get_node("CharacterCollisionShape") as CollisionShape2D
	var player_position: Vector2 = player_collision_shape.global_position as Vector2
	var enemy_position: Vector2 = enemy_collision_shape.global_position as Vector2
	
	player_x = player_position.x
	enemy_x = enemy_position.x

	distance_to_player = abs(player_x - enemy_x)

	process_state()
