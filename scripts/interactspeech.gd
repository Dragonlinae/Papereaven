extends Area2D

var interact_obj_count = 0

@export var speech_bubble : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(Callable(self, "_on_area_entered"))
	area_exited.connect(Callable(self, "_on_area_exited"))

func _on_area_entered(area):
	if area.has_method("interact"):
		interact_obj_count += 1
		speech_bubble.visible = true

func _on_area_exited(area):
	if area.has_method("interact"):
		interact_obj_count -= 1
	if interact_obj_count == 0:
		speech_bubble.visible = false
