extends CharacterBody2D
class_name Entity

## Maximum health (what health gets restored to)
@export var max_health: int = 10

## Current health (also initial health when set)
@export var current_health: int = 10

## Should the tree be removed when health <= 0
@export var destroy_when_dead: bool = true

var damage_factor: float = 1.0

func restore_health():
	current_health = max_health

func take_damage(damage: int):
	current_health -= int(damage * damage_factor)
	if is_dead() and destroy_when_dead:
		queue_free()

func force_full_damage(damage: int):
	current_health -= damage
	if is_dead() and destroy_when_dead:
		queue_free()

func is_dead():
	return current_health <= 0

func is_alive():
	return current_health > 0

func set_damage_factor(new_damage_factor: float):
	print("Set new damage factor to", new_damage_factor)
	damage_factor = new_damage_factor