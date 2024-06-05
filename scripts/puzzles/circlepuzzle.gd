extends Interactable

@export var sprites : Array[Sprite2D] = []

var curr_puzzle_layer = 0
var total_puzzle_layers = 0
var solved = false
var layer_solved : Array[bool] = []
signal open_door

# Called when the node enters the scene tree for the first time.
func _ready():
	total_puzzle_layers = sprites.size()
	for i in range(total_puzzle_layers):
		layer_solved.append(false)
		sprites[i].set_rotation_degrees(randf_range(-180, 180))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (solved):
		return
	if (layer_solved[curr_puzzle_layer]):
		curr_puzzle_layer += 1
		curr_puzzle_layer %= total_puzzle_layers
		return
	sprites[curr_puzzle_layer].rotate(delta)
	if (sprites[curr_puzzle_layer].get_rotation_degrees() > 180):
		sprites[curr_puzzle_layer].rotate(deg_to_rad(-360))
	elif (sprites[curr_puzzle_layer].get_rotation_degrees() < -180):
		sprites[curr_puzzle_layer].rotate(deg_to_rad(360))

func interact():
	if (solved):
		return
	if (abs(sprites[curr_puzzle_layer].get_rotation_degrees()) < 5):
		sprites[curr_puzzle_layer].set_rotation_degrees(0)
		layer_solved[curr_puzzle_layer] = true
	curr_puzzle_layer += 1
	curr_puzzle_layer %= total_puzzle_layers
	for sprite in sprites:
		if (abs(sprite.get_rotation_degrees()) > 5):
			return
	solved = true
	print("Puzzle complete!")
	open_door.emit()
