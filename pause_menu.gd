extends Control

@onready var hud = $"../"

# https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

func _on_save_pressed():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		print("Test")
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		save_game.store_line(json_string)

func _on_load_pressed():
	if not FileAccess.file_exists("user://savegame.save"):
		return

	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var node_data = json.get_data()

		var node = get_node(node_data["node_path"])
		
		if node_data.has("pos_x") && node_data.has("pos_y"):
			node.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		for i in node_data.keys():
			if i == "pos_x" or i == "pos_y":
				continue
			node.set(i, node_data[i])
		
		if node.has_method("update"):
			node.update()

func _on_resume_pressed():
	hud.pauseMenu()

func _on_quit_pressed():
	get_tree().quit()
