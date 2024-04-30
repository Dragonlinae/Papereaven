extends CanvasLayer
@onready var pause_menu = $PauseMenu
var paused = true

func _ready():
	paused = true
	pauseMenu()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	paused = !paused
	if paused:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1

