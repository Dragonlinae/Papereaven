extends Sprite2D

var yvelocity : float = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	yvelocity += gravity*delta
	position.y += yvelocity*delta
	pass
