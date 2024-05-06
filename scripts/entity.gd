extends CharacterBody2D
class_name Entity

@export var max_health: int = 10
@export var current_health: int = 10

func restore_health():
	current_health = max_health

func take_damage(damage: int):
	current_health -= damage

func is_dead():
	return current_health <= 0

func is_alive():
	return current_health > 0
