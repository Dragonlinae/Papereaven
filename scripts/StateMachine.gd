# State.gd
class_name StateMachine
extends Node

# Declare signal events
signal onStateTransition(previousState : String, currentState : String)
signal onStateForceTransition(previousState : String, forcedState : String)

# Declare member variables
var currentState : String = "DEFAULT_START_STATE_PLACEHOLDER"
var valid_states : Array[String] = []

var valid_transitions = {} # {[string] : Array[String]}

# Constructor
func _init(defaultState : String, history_depth :int):
	currentState = defaultState
	return

func validState(state : String) -> bool:
	return valid_states.has(state)

func validTransition(targetState : String) -> bool:
	if not validState(targetState):
		return false
	return valid_transitions[currentState].has(targetState)

func add_state(state : String):
	if validState(state):
		push_warning("State machine already has state", state)
		return
	valid_states.append(state)
	valid_transitions[state] = []
	return

func add_transition(originState : String, targetState : String):
	if not validState(originState) or not validState(targetState):
		push_error("One or more parameter states is not a valid state in target state machine")
		return
	if valid_transitions[originState].has(targetState):
		push_error("Duplicate transition added to target state machine")
		return
	valid_transitions[originState].append(targetState)
	return

func override_state(forcedState : String):
	var previousState : String = currentState
	currentState = forcedState
	onStateTransition.emit(previousState, currentState)
	onStateForceTransition.emit(previousState, currentState)

func transition_state(targetState : String):
	if not validTransition(targetState):
		push_warning("Invalid state transition detected.")
		return
	if targetState == currentState:
		push_warning("Self-looping state transition detected.")
		return
	var previousState : String = currentState
	currentState = targetState
	onStateTransition.emit(previousState, currentState)

