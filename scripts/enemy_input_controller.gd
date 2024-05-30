class_name EnemyInputHandler
extends InputHandler

@export var logic_state: EnemyLogicState

func _init():
	print("An EIH has been instantiated")

# TODO: Implement enemy logic state machine

func get_movement_direction() -> float:
	return 0.5

func get_jump_input() -> bool:
	return false

func get_attack_input() -> bool:
	return true

func get_dash_input() -> bool:
	return false

func get_attack_heavy_input() -> bool:
	return false

func get_block_input() -> bool:
	return false

func get_interact_input() -> bool:
	return false