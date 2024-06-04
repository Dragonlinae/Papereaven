extends Node2D
class_name Checkpoint

var activated = false
var deactivated_texture = load("res://assets/flag.png")
var activated_texture = load("res://assets/flag_filled.png")

func deactivate():
	activated = false
	update()

func _on_area_2d_area_entered(area):

	if area.get_parent() is CharacterController && !activated:
		activated = true

		var prev_checkpoint : Checkpoint = area.get_parent().current_checkpoint
		if prev_checkpoint != null:
			prev_checkpoint.deactivate()

		area.get_parent().current_checkpoint = self
		update()

func save():
	var save_dict = {
		"node_path": get_path(),
		"activated": activated,
	}
	return save_dict

func update():
	if activated:
		$Sprite2D.texture = activated_texture
		get_node("/root/Node2D/Player").current_checkpoint = self
	else:
		$Sprite2D.texture = deactivated_texture
