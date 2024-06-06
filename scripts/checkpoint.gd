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
		return true
	else:
		var grabsprite : Node2D = player.get_node("Grab")
		var crumpled : Sprite2D = player.get_node("Crumpled")
		var player_transform : Node = player.get_node("RemoteTransform2D")
		var charsprite : CollisionShape2D = player.get_node("CharacterCollisionShape")

		player.set_script(null)
		for child in player.get_children():
			if child not in [grabsprite, crumpled, player_transform, charsprite]:
				child.queue_free()
		
		player.remove_child(grabsprite)
		get_parent().add_child(grabsprite)
		player.remove_child(crumpled)
		get_parent().add_child(crumpled)
		await get_tree().create_timer(1).timeout
		grabsprite.setpos(player.global_position)
		player.remove_child(player_transform)
		grabsprite.add_child(player_transform)
		await get_tree().create_timer(1).timeout
		grabsprite.release()
		await get_tree().create_timer(1).timeout
		player.queue_free()
		grabsprite.grab()
		await get_tree().create_timer(1).timeout
		grabsprite.release()
		crumpled.global_position = grabsprite.global_position
		crumpled.yvelocity = 0.0
		grabsprite.remove_child(player_transform)
		crumpled.add_child(player_transform)
		crumpled.visible = true
		await get_tree().create_timer(1).timeout

		await get_tree().create_timer(2).timeout
		grabsprite.hidehand()
		crumpled.visible = false

		SceneData.target_scene_path = target_scene_path
		get_tree().change_scene_to_file("res://scenes/levels/loading_screen.tscn")
		return false
