class_name CombatState
extends StateMachine

func _init():
	super("Idle")
	add_state("Attacking")
	add_state("Blocking")
	add_state("Stagger")

	add_transition("Idle", "Attacking")
	add_transition("Attacking", "Idle")
	add_transition("Idle", "Blocking")
	add_transition("Blocking", "Idle")
	add_transition("Idle", "Stagger")
	add_transition("Stagger", "Idle")
	
	add_transition("Attacking", "Stagger")
	add_transition("Blocking", "Stagger")