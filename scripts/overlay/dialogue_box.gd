extends CanvasLayer

var dialogues : Array[String] = []
var currentDialogue : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_dialogue():
	visible = true
	if currentDialogue < dialogues.size():
		get_node("ColorRect/Label").text = dialogues[currentDialogue]
		print("Current dialogue: " + dialogues[currentDialogue])
		currentDialogue += 1
	else:
		queue_free()
