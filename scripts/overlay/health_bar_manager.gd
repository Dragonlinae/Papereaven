class_name HealthGUI
extends CanvasLayer

var health_progress_bar : TextureProgressBar
var progress_value : float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
  health_progress_bar = get_node("HealthBar")

func update_health(curr_health : float, max_health : float):
  progress_value = curr_health / max_health * 100
  print(progress_value)
  health_progress_bar.value = progress_value
