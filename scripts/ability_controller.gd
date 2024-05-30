class_name AbilityController
extends Node

## Entity associated with the abilitycontroller
@export var entity: Entity
@export var input_handler: PlayerInputHandler

@export var ability1: Ability

func cast_ability1():
	ability1.cast_ability(entity)

func _process(_delta):
	if input_handler.get_ability_input():
		cast_ability1()