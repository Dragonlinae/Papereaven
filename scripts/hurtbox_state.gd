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
	print("Hurtbox connecting...")
	# internalTimer.timeout.connect(_on_internal_timer_timeout)

func _on_parry_end():
	print("Parry ended")
	print("Transitioning to block state")
	transition_state("Block")
	# startBlockTimer()

func _on_block_end():
	print("Block ended")
	print("Transitioning to hittable state")
	transition_state("Hittable")

func _on_internal_timer_timeout():
	print("Timer timed out!")
	if current_state == "Block":
		_on_block_end()
	elif current_state == "Parry":
		_on_parry_end()

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

func startParry():
	if current_state != "Hittable":
		return
	print("Transitioning to parry state")
	transition_state("Parry")
	# startParryTimer()

func cancel_internal_timer():
	internalTimer.stop()

func force_hittable():
	override_state("Hittable")

# TODO: Implement state process ticks (?)

# TODO: Implement state on_transition function (?)
