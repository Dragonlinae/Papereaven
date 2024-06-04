class_name portal_activator
extends Node

@export var target_portal: Portal

func activate():
	print("Activated")
	target_portal.can_interact = true

func deactivate():
	target_portal.can_interact = false

func _on_character_body_2d_boss_spawned(boss_entity: Entity):
	print("Spwaned")
	boss_entity.died.connect(activate)