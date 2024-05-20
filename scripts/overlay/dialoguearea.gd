extends Area2D

@export var dialogues : Resource
var dialogue_box_scene = preload("res://scenes/overlay/dialogue_box.tscn")

var dialogue_box = null

func interact():
	if dialogue_box == null:
		dialogue_box = dialogue_box_scene.instance()
		add_child(dialogue_box)
		dialogue_box.dialogues = dialogues
		dialogue_box.connect("dialogue_finished", self, "_on_dialogue_finished")
		dialogue_box.show()
	else:
		dialogue_box.show()
