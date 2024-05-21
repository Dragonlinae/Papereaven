extends WorldEnvironment

var glow_intensity = 0.0
var increasing = true
var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if (time < 2.0):
		glow_intensity = lerp(0.0, 20.0, time/2)
	elif (time >= 2.0 and time < 4.0):
		glow_intensity = lerp(20.0, 2.0, (time-2)/2)
	elif (time >= 4.0 and time < 10.0):
		glow_intensity = lerp(2.0, 0.0, sqrt((time-4)))
	elif (time >= 10.0):
		queue_free()
	
	environment.glow_intensity = glow_intensity
