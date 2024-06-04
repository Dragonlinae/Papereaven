class_name Portal
extends Interactable

@export_file var target_scene_path: String = "res://scenes/homelevel.tscn"

@export var can_interact: bool = true

func interact():
	if not can_interact:
		return
	SceneData.target_scene_path = target_scene_path
	get_tree().change_scene_to_file("res://scenes/levels/loading_screen.tscn")
