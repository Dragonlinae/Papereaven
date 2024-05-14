class_name MovementState
extends StateMachine

var input_interface : InputHandler
var char_controller : CharacterController
var animation_playback: AnimationNodeStateMachinePlayback

@export var coyote_time : float = 0.10
var coyote_window : bool = false
var floor_prev : bool = false
var coyote_timer : Timer

var dash_timer_elapsed : bool = true
var used_dash : bool = false
var dash_factor : int = 10

func _on_coyote_timeout():
	coyote_window = false

func _on_dash_timer_timeout():
	dash_timer_elapsed = true

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
	coyote_timer = Timer.new()
	coyote_timer.autostart = false
	coyote_timer.one_shot = false
	coyote_timer.wait_time = coyote_time
	if not coyote_timer.is_stopped():
		coyote_timer.stop()
	coyote_timer.timeout.connect(_on_coyote_timeout)

func _inject_char_controller(controller : CharacterController):
	char_controller = controller

func _inject_input_interface(interface : InputHandler):
	input_interface = interface

func handle_jump():
	# TODO: Add checks for stun to prevent jump
	var jump_input : bool = input_interface.get_jump_input()
	if jump_input and (char_controller.is_on_floor() or coyote_window):
		char_controller.jump()
		coyote_window = false

func process_idle():
	var movement_direction : float = input_interface.get_movement_direction()
	if movement_direction:
		transition_state("Moving")
	elif false:
		transition_state("Dash")
	else:
		char_controller.velocity.x = 0
		char_controller.play_animation("idle")

func process_moving():
	var movement_direction : float = input_interface.get_movement_direction()

	if char_controller.is_on_floor() and dash_timer_elapsed:
		used_dash = false

	if input_interface.get_dash_input() and !used_dash and movement_direction:
		dash_timer_elapsed = false
		$DashTimer.start()
		transition_state("Dash")
	if movement_direction:
		# TODO: Add checks for stun or anything that might prevent the character from moving
		char_controller.velocity.x = movement_direction * char_controller.move_velocity * char_controller.animation_walk
		char_controller.play_animation("walk")
	else:
		transition_state("Idle")

func process_dash():
	if dash_timer_elapsed:
		transition_state("Idle")
		char_controller.velocity.x = 0
	else:
		var movement_direction : float = input_interface.get_movement_direction()
		char_controller.velocity.x = dash_factor * movement_direction * char_controller.move_velocity
		char_controller.velocity.y = 0

	used_dash = true

func _on_state_transition(_previous_state : String, new_state : String):
	if new_state == "Idle":
		process_idle()
	elif new_state == "Moving":
		process_moving()
	elif new_state == "Dash":
		process_dash()
	else:
		assert(false, "Unreachable state")

func process_state():
	if !char_controller.is_on_floor() and floor_prev:
		coyote_window = true
		coyote_timer.start()

	match current_state:
		"Idle":
			process_idle()
		"Moving":
			process_moving()
		"Dash":
			process_dash()
	handle_jump()
	floor_prev = char_controller.is_on_floor()
