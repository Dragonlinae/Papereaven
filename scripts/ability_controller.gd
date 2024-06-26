class_name AbilityController
extends Node

## Entity associated with the abilitycontroller
@export var entity: Entity
@export var input_handler: PlayerInputHandler

@export var ability1_unlocked: bool
@export var ability1: Ability

func cast_ability1():
	ability1.cast_ability()

func _process(_delta):
	if input_handler.get_ability_input() and ability1_unlocked:
		cast_ability1()
