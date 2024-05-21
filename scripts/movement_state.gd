class_name MovementState
extends StateMachine

var input_interface: InputHandler
var char_controller: CharacterController
var animation_playback: AnimationNodeStateMachinePlayback

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## Grace period after leaving the ground that you can still jump.
@export var coyote_time: float = 0.2
var coyote_window : bool = false
var floor_prev : bool = false
var coyote_timer: Timer

var used_second_jump = false
var do_second_jump = false
var did_manual_jump = false

## Duration of dash (note: May replace with animation in future)
@export var dash_time: float = 0.2
var dash_timer: Timer
var dashing : bool = false
var used_dash : bool = false
var dash_factor : int = 10
var dash_direction : float = 1

func _on_coyote_timeout():
	coyote_window = false

func _on_dash_timeout():
	dashing = false

func _init():
	super("Idle")
	add_state("Moving")
	add_state("Dash")

	add_transition("Idle", "Moving")
	add_transition("Idle", "Dash")
	add_transition("Moving", "Dash")
	add_transition("Moving", "Idle")
	add_transition("Dash", "Moving")
	add_transition("Dash", "Idle")

func _ready():
	# Initialize timers
	coyote_timer = Timer.new()
	add_child(coyote_timer)
	coyote_timer.autostart = false
	coyote_timer.one_shot = false
	coyote_timer.wait_time = coyote_time
	coyote_timer.timeout.connect(_on_coyote_timeout)
	
	dash_timer = Timer.new()
	add_child(dash_timer)
	dash_timer.autostart = false
	dash_timer.one_shot = false
	dash_timer.wait_time = dash_time
	dash_timer.timeout.connect(_on_dash_timeout)

func _inject_char_controller(controller: CharacterController):
	char_controller = controller

func _inject_input_interface(interface: InputHandler):
	input_interface = interface

func handle_jump():
	# TODO: Add checks for stun to prevent jump
	var jump_input: bool = input_interface.get_jump_input()
	if !jump_input and !used_second_jump:
		do_second_jump = true

	if jump_input:
		if char_controller.is_on_floor() or coyote_window:
			char_controller.jump()
			coyote_window = false
			do_second_jump = false
			did_manual_jump = true
		elif do_second_jump:
			char_controller.jump()
			do_second_jump = false
			used_second_jump = true

func can_move() -> bool:
	if char_controller.combat_state.current_state == "Idle":
		return true
	else:
		return false

func process_idle():
	var movement_direction: float = input_interface.get_movement_direction()
	if movement_direction and can_move():
		transition_state("Moving")
		char_controller.play_animation("walk")
	elif false:
		transition_state("Dash")
	else:
		char_controller.velocity.x = 0
		
		# only start idle animation when the combat state isn't doing anything
		if can_move():
			char_controller.play_animation("idle")

func process_moving():
	var movement_direction : float = input_interface.get_movement_direction()

	if char_controller.is_on_floor() and !dashing and can_move():
		used_dash = false

	if input_interface.get_dash_input() and !used_dash and can_move():
		dashing = true
		dash_direction = movement_direction
		dash_timer.start()
		transition_state("Dash")
	if movement_direction:
		# TODO: Add checks for stun or anything that might prevent the character from moving
		char_controller.velocity.x = movement_direction * char_controller.move_velocity
	else:
		transition_state("Idle")

func process_dash():
	if !dashing:
		transition_state("Idle")
		char_controller.velocity.x = 0
	else:
		char_controller.velocity.x = dash_factor * dash_direction * char_controller.move_velocity
		char_controller.velocity.y = 0
		used_dash = true


# Is this even used?
func _on_state_transition(_previous_state: String, new_state: String):
	print("new_state " + new_state)
	if new_state == "Idle":
		process_idle()
	elif new_state == "Moving":
		process_moving()
	elif new_state == "Dash":
		process_dash()
	else:
		assert(false, "Unreachable state")

func process_state():
	if !char_controller.is_on_floor():
		if floor_prev and !did_manual_jump:
			coyote_window = true
			coyote_timer.start()
	else:
		did_manual_jump = false
		used_second_jump = false

	match current_state:
		"Idle":
			process_idle()
		"Moving":
			process_moving()
		"Dash":
			process_dash()
	handle_jump()
	floor_prev = char_controller.is_on_floor()
