class_name CharacterController
extends CharacterBody2D

## Pixels per second horizontal movement velocity
@export var move_velocity : float = 200.0

## Pixels per second jump velocity
@export var jump_velocity : float = 200.0

## Input Handler Interface for Character
@export var input_handler_type : String = "Player"

var movement_state : MovementState
var input_handler : InputHandler

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	assert(input_handler_type == "Player" or input_handler_type == "NPC", "Invalid Input Handler Type")
	if input_handler_type == "Player":
		input_handler = PlayerInputHandler.new()
	else:
		input_handler = InputHandler.new()
	movement_state = MovementState.new(input_handler, self)

func apply_gravity(delta : float):
	if not is_on_floor():
		velocity.y += gravity * delta
	return

func jump():
	velocity.y = -1 * jump_velocity

# Do we want to put movement into a function too?

func _physics_process(delta : float):
	apply_gravity(delta)
	movement_state.process_state()
	
	move_and_slide()