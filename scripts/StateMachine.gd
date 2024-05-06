# State.gd
class_name StateMachine
extends Node

# Declare signal events
signal onStateTransition(previousState : String, currentState : String)
signal onStateForceTransition(previousState : String, forcedState : String)

# Declare member variables
var current_state : String = "DEFAULT_START_STATE_PLACEHOLDER"
var valid_states : Array[String] = []

var valid_transitions = {} # {[string] : Array[String]}

func validState(state : String) -> bool:
	return valid_states.has(state)

func validTransition(target_state : String) -> bool:
	if not validState(target_state):
		return false
	return valid_transitions[current_state].has(target_state)

func add_state(state : String):
	if validState(state):
		push_warning("State machine already has state", state)
		return
	valid_states.append(state)
	valid_transitions[state] = []

func add_transition(origin_state : String, target_state : String):
	if not validState(origin_state) or not validState(target_state):
		push_error("One or more parameter states is not a valid state in target state machine")
		return
	if valid_transitions[origin_state].has(target_state):
		push_error("Duplicate transition added to target state machine")
		return
	valid_transitions[origin_state].append(target_state)

func override_state(forced_state : String):
	var prev_state : String = current_state
	current_state = forced_state
	onStateTransition.emit(prev_state, current_state)
	onStateForceTransition.emit(prev_state, current_state)

func transition_state(target_state : String):
	if not validTransition(target_state):
		push_warning("Invalid state transition detected.")
		return
	if target_state == current_state:
		push_warning("Self-looping state transition detected.")
		return
	var prev_state : String = current_state
	current_state = target_state
	onStateTransition.emit(prev_state, current_state)

# Constructor
func _init(default_state : String):
	current_state = default_state
	add_state(default_state)
