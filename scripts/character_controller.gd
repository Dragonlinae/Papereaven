class_name CharacterController
extends CharacterBody2D

## Pixels per second horizontal movement velocity
@export var move_velocity: float = 200.0

## Pixels per second jump velocity
@export var jump_velocity: float = 200.0

## Input Handler Interface for Character
@export var input_handler: InputHandler
@export var movement_state: MovementState
@export var combat_state: CombatState

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	return

func _ready():
	set_physics_process(false)
	call_deferred("_ready_deferred")

func _ready_deferred():
	movement_state._inject_char_controller(self)
	movement_state._inject_input_interface(input_handler)
	set_physics_process(true)
	return

func get_movement_state() -> MovementState:
	return movement_state

func get_combat_state() -> CombatState:
	return combat_state

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta
	return

func jump():
	velocity.y = -1 * jump_velocity

# Do we want to put movement into a function too?

func _physics_process(delta: float):
	apply_gravity(delta)
	movement_state.process_state()
	
	move_and_slide()