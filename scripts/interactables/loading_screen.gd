extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello, World!")
	print("Changing scene to: " + SceneData.target_scene_path)
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(SceneData.target_scene_path)
	print("Goodbye, World!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
