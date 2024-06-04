extends Node2D

@export var target : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if target != null:
		target.open_door.connect(destroy_door)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func destroy_door():
	queue_free()
