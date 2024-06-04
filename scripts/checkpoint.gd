extends Node2D
class_name Checkpoint

@export var spawnpoint = false
@export var target_scene_path: String = ""

var activated = false

var activated_texture = load("res://assets/flag_filled.png")

func _on_area_2d_area_entered(area):

	if area.get_parent() is CharacterController&&!activated:
		activated = true
		area.get_parent().current_checkpoint = self
		$Sprite2D.texture = activated_texture

func teleport(player: CharacterController):
	print("Teleporting")
	print(target_scene_path)
	if target_scene_path == "":
		player.global_position = global_position
	else:
		SceneData.target_scene_path = target_scene_path
		get_tree().change_scene_to_file("res://scenes/levels/loading_screen.tscn")