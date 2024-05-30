extends CanvasLayer

var combo_counter : Label
var progress_value : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	combo_counter = get_node("Progress")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_value -= 30*delta
	combo_counter.material.set_shader_parameter("progress", progress_value)
	pass

func recombo(combo_count):
	combo_counter.text = str(combo_count) + "x COMBO"
	progress_value = 100.0
	combo_counter.material.set_shader_parameter("progress", progress_value)
	combo_counter.material.set_shader_parameter("width", combo_counter.size.x)
	
	pass
