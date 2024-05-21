class_name ComboTracker
extends Node

@export var combo_decay_time: float = 1.5

var combo_timer: Timer
var combo_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Set up the connection
	var char_controller: CharacterController = get_parent() as CharacterController
	if char_controller == null or not char_controller is CharacterController:
		return
	
	var char_hitbox: Hitbox = char_controller.get_node("Hitbox") as Hitbox
	if char_hitbox == null or not char_hitbox is Hitbox:
		return

	# Set up the timer
	combo_timer = Timer.new()
	combo_timer.autostart = false
	combo_timer.one_shot = false
	combo_timer.wait_time = combo_decay_time
	if not combo_timer.is_stopped():
		combo_timer.stop()
	combo_timer.timeout.connect(_on_combo_timeout)

	add_child(combo_timer)

	return

func _on_hit_registered():
	combo_count += 1
	print(combo_count)
	combo_timer.stop()
	combo_timer.start()
	return

func _on_combo_timeout():
	print("Combo decayed back to 0")
	combo_count = 0
	combo_timer.stop()
	return

func _on_hitbox_hitbox_triggered(_hurtbox: Hurtbox, _hitbox: Hitbox):
	_on_hit_registered()
