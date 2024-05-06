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
# TODO: Implement get combat inputs
