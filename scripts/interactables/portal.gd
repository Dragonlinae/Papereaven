extends Interactable

@export_file var target_scene_path : String = "res://scenes/homelevel.tscn"

func interact():
  SceneData.target_scene_path = target_scene_path
  get_tree().change_scene_to_file("res://scenes/levels/loading_screen.tscn")
