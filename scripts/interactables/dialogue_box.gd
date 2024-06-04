extends CanvasLayer

var dialogues : PackedStringArray
var current_dialogue : int = 0
var dialogue_line : PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_dialogue():
	visible = true
	if current_dialogue < dialogues.size():
		dialogue_line = dialogues[current_dialogue].split("`")
		get_node("ColorRect/Title").text = dialogue_line[0].strip_edges()
		get_node("ColorRect/Frame/pfp").texture = load("res://assets/overlay/" + dialogue_line[1].strip_edges())
		get_node("ColorRect/Content").text = dialogue_line[2].strip_edges()
		print("Current dialogue: " + dialogues[current_dialogue])
		current_dialogue += 1
	else:
		queue_free()
