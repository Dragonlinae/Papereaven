class_name CharacterController
extends Entity

## Pixels per second horizontal movement velocity
@export var move_velocity: float = 200.0

## Pixels per second jump velocity
@export var jump_velocity: float = 200.0

## Input Handler Interface for Character
@export var input_handler: InputHandler
@export var movement_state: MovementState
@export var combat_state: CombatState

@export var animation_tree: AnimationTree
@export var animation_walk: int = 0
var animation_playback: AnimationNodeStateMachinePlayback

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	pass

func _ready():
	set_physics_process(false)
	call_deferred("_ready_deferred")

func _ready_deferred():
	movement_state._inject_char_controller(self)
	movement_state._inject_input_interface(input_handler)

	combat_state._inject_char_controller(self)
	combat_state._inject_input_interface(input_handler)

	if animation_tree is AnimationTree:
		animation_playback = animation_tree.get("parameters/main/playback")

	set_physics_process(true)

func play_animation(new_state: String):
	if animation_playback != null:
		#print(animation_playback.get_current_node())
		if animation_playback.get_current_node() != new_state:
			animation_playback.travel(new_state)

func get_movement_state() -> MovementState:
	return movement_state

func get_combat_state() -> CombatState:
	return combat_state

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta

func jump():
	velocity.y = -1 * jump_velocity
	if velocity.x != 0:
		velocity.x += abs(velocity.x) / velocity.x * 100

# Do we want to put movement into a function too?

func _process(delta: float):
	if is_dead():
		respawn()

func _physics_process(delta: float):
	apply_gravity(delta)
	movement_state.process_state()
	combat_state.process_state()
	
	move_and_slide()
	
# Checkpoint logic
var current_checkpoint : Checkpoint
func respawn():
	if current_checkpoint != null:
		global_position = current_checkpoint.global_position
		restore_health()
	
