extends Entity

var acceleration: float = 0.0
var damage: float = 0.0
var lifetime: float = 0.0

func _physics_process(delta):
	velocity.x *= (1.0 + acceleration * delta)

	position += velocity * delta

	lifetime -= delta

	if lifetime <= 0.0:
		queue_free()
