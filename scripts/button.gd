extends Area2D

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body.get_path())
	$Sprite2D.region_rect = Rect2(1935, 990, 100, 35)

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	$Sprite2D.region_rect = Rect2(1680, 990, 100, 35)
