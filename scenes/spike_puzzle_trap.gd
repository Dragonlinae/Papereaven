extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.region_rect = Rect2(1680, 990, 100, 35)


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#if body.is_in_group("Player"):
		#print("player touching button")
	$Button.region_rect = Rect2(1935, 990, 100, 35)


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	$Button.region_rect = Rect2(1680, 990, 100, 35)
