class_name CharacterController
extends CharacterBody2D

## Pixels per second horizontal movement velocity
@export var move_velocity : float = 200.0

## Pixels per second jump velocity
@export var jump_velocity : float = 200.0

## Input Handler Interface for Character
@export var input_interface : InputHandler

var movement_state : MovementState

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	print("Initializing player controller")
	movement_state = MovementState.new(input_interface)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump logic
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -1 * jump_velocity
	
	# Input
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * move_velocity
	else:
		velocity.x = move_toward(velocity.x, 0, move_velocity)
	
	move_and_slide()