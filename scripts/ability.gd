class_name Ability
extends Node

@export var cooldown_time: float
var on_cooldown: bool = false
var cooldown_timer: Timer

@export var ability_time: float
var ability_timer: Timer

func _ready():
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = false
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.timeout.connect(_on_cooldown_timeout)

	ability_timer = Timer.new()
	add_child(ability_timer)
	ability_timer.autostart = false
	ability_timer.one_shot = false
	ability_timer.wait_time = ability_time
	ability_timer.timeout.connect(_on_ability_timout)

func start_cooldown():
	on_cooldown = true
	cooldown_timer.start()

func execute_ability():
	var entity: Entity = get_parent().get_parent() as Entity
	entity.set_hittable(false)
	ability_timer.start()
	return

func cast_ability():
	if (on_cooldown): return
	else:
		start_cooldown()
		execute_ability()
	pass

func _on_cooldown_timeout():
	on_cooldown = false
	print("Cooldown expired")

func _on_ability_timout():
	var entity: Entity = get_parent().get_parent() as Entity
	entity.set_hittable(true)