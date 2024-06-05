extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var material = PhysicsMaterial.new()
	material.friction = 0.1
	#$CollisionShape2D.shape.set_material(material)
