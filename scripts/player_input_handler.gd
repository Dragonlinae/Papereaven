class_name PlayerInputHandler
extends InputHandler

func _init():
	print("Test")

func get_movement_direction() -> float:
	var direction_x : float = Input.get_axis("left", "right")
	return direction_x

func get_jump_input() -> bool:
	var jump_input : bool = Input.is_action_pressed("jump")
	return jump_input