class_name Ability
extends Node

@export var cooldown_time: float
var on_cooldown: bool = false
var cooldown_timer: Timer

func _ready():
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = false
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.timeout.connect(_on_cooldown_timeout)

func start_cooldown():
	on_cooldown = true
	cooldown_timer.start()

func cast_ability(entity: Entity):
	if (on_cooldown): return
	else:
		start_cooldown()
		print("Placholder ability call")
	pass

func _on_cooldown_timeout():
	on_cooldown = false
	print("Cooldown expired")