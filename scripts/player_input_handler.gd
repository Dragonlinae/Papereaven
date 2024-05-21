class_name PlayerInputHandler
extends InputHandler

func _init():
	print("A PIH has been instantiated")

func get_movement_direction() -> float:
	var direction_x: float = Input.get_axis("left", "right")
	return direction_x

func get_jump_input() -> bool:
	var jump_input: bool = Input.is_action_pressed("jump")
	return jump_input

func get_attack_input() -> bool:
	var attack_input: bool = Input.is_action_pressed("attack")
	return attack_input

func get_dash_input() -> bool:
	var dash_input: bool = Input.is_action_pressed("dash")
	return dash_input


func get_attack_heavy_input() -> bool:
	var attack_heavy_input: bool = Input.is_action_pressed("attack heavy")
	return attack_heavy_input

func get_block_input() -> bool:
	var block_input: bool = Input.is_action_pressed("block")
	return block_input

func get_interact_input() -> bool:
	var interact_input: bool = Input.is_action_just_pressed("interact")
	return interact_input

# TODO: Implement get combat inputs
