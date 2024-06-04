class_name portal_activator
extends Node

@export var target_portal: Portal

func activate():
	target_portal.can_interact = true

func deactivate():
	target_portal.can_interact = false