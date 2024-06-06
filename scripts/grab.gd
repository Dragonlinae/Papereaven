extends Node2D

var openhand : Sprite2D
var closedhand : Sprite2D
var initialpos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	openhand = get_node("Open")
	closedhand = get_node("Grab")
	initialpos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = initialpos + Vector2(randf_range(-5, 5), randf_range(-5, 5))
	pass

func release():
	openhand.visible = true
	closedhand.visible = false

func grab():
	openhand.visible = false
	closedhand.visible = true

func hidehand():
	openhand.visible = false
	closedhand.visible = false

func setpos(pos: Vector2):
	initialpos = pos
