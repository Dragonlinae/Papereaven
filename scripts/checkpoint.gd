extends Node2D
class_name Checkpoint

@export var spawnpoint = false

var activated = false

var activated_texture = load("res://assets/flag_filled.png")

func _on_area_2d_area_entered(area):
	if area.get_parent() is CharacterController && !activated:
		activated = true
		area.get_parent().current_checkpoint = self
		$Sprite2D.texture = activated_texture
