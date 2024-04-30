extends Node2D

#@export var spawnpoint = false
#
#var activated = false
#
#var activated_texture = load("res://assets/flag_filled.png")

func ready():
	print("ready")

#func _on_area_2d_area_entered(area):
	#if area.get_parent() is Character && !activated:
		#activated = true
		#$Sprite2D.texture = activated_texture
