class_name ComboTracker
extends Node

@export var combo_decay_time: float = 3

var combo_timer: Timer
var combo_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up the timer
	combo_timer = Timer.new()
	combo_timer.autostart = false
	combo_timer.one_shot = false
	combo_timer.wait_time = combo_decay_time
	if not combo_timer.is_stopped():
		combo_timer.stop()
	combo_timer.timeout.connect(_on_combo_timeout)

	add_child(combo_timer)

func _on_hit_registered():
	combo_count += 1
	print(combo_count)
	combo_timer.stop()
	combo_timer.start()

func end_combo():
	print("Combo decayed back to 0")
	combo_count = 0
	combo_timer.stop()

func _on_combo_timeout():
	end_combo()

func _on_hitbox_hitbox_triggered(_hurtbox: Hurtbox, _hitbox: Hitbox):
	_on_hit_registered()

func _on_character_controller_damage_taken(_damage_amount: Variant):
	print("Damage taken! Resetting combo!")
	end_combo()
