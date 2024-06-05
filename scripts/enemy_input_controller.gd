class_name EnemyInputHandler
extends InputHandler

@export var logic_state: EnemyLogicState

func _init():
	print("An EIH has been instantiated")

# TODO: Implement enemy logic state machine

func get_movement_direction() -> float:
	var distance_to_player: float = logic_state.distance_to_player
	var player_x: float = logic_state.player_x
	var enemy_x: float = logic_state.enemy_x

	if logic_state.current_state == "Following":
		var signFlip = 1
		if distance_to_player < logic_state.close_distance:
			signFlip = -1
		if distance_to_player < logic_state.far_distance and distance_to_player > logic_state.close_distance:
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
