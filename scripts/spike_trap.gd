class_name SpikeTrap extends Hitbox

@export var actuate:bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	if actuate:
		$AnimationPlayer.play("activate")
	else:
		$CollisionShape2D.disabled = false

func spikes_off():
	$AnimationPlayer.play("off")
