class_name ExperienceManager
extends Node

@export var current_level: int = 1
@export var max_level: int = 3

@export var current_experience: int = 0
@export var required_experience: int = 50

@export var hp_per_level: int = 10
@export var dmg_boost_per_level: float = 0.25

@export var entity: Entity
@export var hitbox: Hitbox

func _ready():
	pass

func level_up():
	if current_level == max_level:
		return
	current_level += 1

	hitbox.damage_mult += dmg_boost_per_level
	entity.max_health += hp_per_level

func add_experience(experience_to_add: int):
	current_experience += experience_to_add
	while current_experience > required_experience:
		level_up()
		current_experience -= required_experience