class_name HurtboxState
extends StateMachine

## Time spent in the parry window
@export var parry_time : float

## Time spent in the block window
@export var block_time : float

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

# TODO: Implement function that creates timer on parry start

# TODO: Implement function that creates timer on block start

# TODO: Implement listeners for timers (?)

# TODO: Implement timer cancellation mechanism -- If you get block-broken, don't want to set state!

# TODO: Implement state process ticks (?)

# TODO: Implement state on_transition function (?)
