class_name InputHandler
extends Node

func _init():
	assert(false, "Virtual class cannot be instantiated or called")

func get_movement_direction() -> float:
	assert(false, "Virtual function must be defined in child class")
	return 0.0

func get_jump_input() -> bool:
	assert(false, "Virtual function must be defined in child class")
	return false

func get_attack_input() -> bool:
	assert(false, "Virtual function must be defined in child class")
	return false

func get_dash_input() -> bool:
	assert(false, "Virtual function must be defined in child class")
	return false

func get_attack_heavy_input() -> bool:
	assert(false, "Virtual function must be defined in child class")
	return false

func get_block_input() -> bool:
	assert(false, "Virtual function must be defined in child class")
	return false

# TODO: Implement virual func protos for combat input
