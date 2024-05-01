extends StateMachine

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