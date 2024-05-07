class_name HurtboxState
extends StateMachine

## Time spent in the parry window
@export var parry_time: float

## Time spent in the block window
@export var block_time: float

var internalTimer: Timer = Timer.new()

func _init():
	super("Hittable")
	add_state("Invulnerable")
	add_state("Parry")
	add_state("Block")

	add_transition("Hittable", "Parry")
	add_transition("Parry", "Block")
	add_transition("Block", "Hittable")
	add_transition("Hittable", "Invulnerable")
	add_transition("Invulnerable", "Hittable")

func _ready():
	internalTimer.timeout.connect(_on_internal_timer_timeout)

func _on_parry_end():
	print("Parry ended")
	transition_state("Block")
	startBlockTimer()
	pass

func _on_block_end():
	print("Block ended")
	pass

func _on_internal_timer_timeout():
	if current_state == "Block":
		_on_block_end()
		return
	elif current_state == "Parry":
		_on_parry_end()
		return
	return

func startParryTimer():
	if current_state != "Parry":
		return
	internalTimer.wait_time = parry_time
	internalTimer.start()

func startBlockTimer():
	if current_state != "Block":
		return
	internalTimer.wait_time = block_time
	internalTimer.start()

func cancel_internal_timer():
	internalTimer.stop()

func force_hittable():
	override_state("Hittable")

# TODO: Implement state process ticks (?)

# TODO: Implement state on_transition function (?)
