extends Area2D

@export var dialogues : Array[String] = []
var dialogue_box_scene = preload("res://scenes/overlay/dialogue_box.tscn")

var dialogue_box = null
var spoken = false

func interact():
	if dialogue_box == null:
		spoken = true
		dialogue_box = dialogue_box_scene.instantiate()
		add_child(dialogue_box)
		dialogue_box.dialogues = dialogues
		dialogue_box.next_dialogue()
	else:
		dialogue_box.next_dialogue()

func _ready():
	area_exited.connect(Callable(self, "_on_area_exited"))
	print("ready")

func _on_area_exited(area):
	if dialogue_box != null:
		dialogue_box.queue_free()
		dialogue_box = null
