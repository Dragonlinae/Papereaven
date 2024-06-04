class_name EnemyInputHandler
extends InputHandler

@export var logic_state: EnemyLogicState

func _init():
	print("An EIH has been instantiated")

# TODO: Implement enemy logic state machine

func get_movement_direction() -> float:
	if logic_state.current_state == "Following":
		var root_node: Node = get_tree().get_root() as Node
		var scene_root: Node2D = root_node.get_node("Node2D") as Node2D
		var player: CharacterController = scene_root.get_node("Player") as CharacterController
		var enemy: CharacterController = get_parent() as CharacterController

		if enemy == null:
			return 0

		var player_collision_shape: CollisionShape2D = player.get_node("CharacterCollisionShape") as CollisionShape2D
		var enemy_collision_shape: CollisionShape2D = enemy.get_node("CharacterCollisionShape") as CollisionShape2D

		var player_position: Vector2 = player_collision_shape.global_position as Vector2
		var enemy_position: Vector2 = enemy_collision_shape.global_position as Vector2

		var player_x: float = player_position.x
		var enemy_x: float = enemy_position.x

		var distance_to_player: float = abs(player_x - enemy_x)

		var signFlip = 1
		if distance_to_player < 250:
			signFlip = -1
		if distance_to_player < 300 and distance_to_player > 250:
			# close enough, striking distance
			return 0

		if (player_x > enemy_x):
			#print("Moving Right")
			return 1 * signFlip
		else:
			#print("Moving Left")
			return - 1 * signFlip
	else:
		return 0

func get_jump_input() -> bool:
	return false

func get_attack_input() -> bool:
	return logic_state.current_state == "Attacking"

func get_dash_input() -> bool:
	return false

func get_attack_heavy_input() -> bool:
	return false

func get_block_input() -> bool:
	return false

func get_interact_input() -> bool:
	return false
