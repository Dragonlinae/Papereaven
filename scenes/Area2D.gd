extends Area2D

@export var door_rigidbody: RigidBody2D

func _on_area_entered(_area: Area2D):
	print("Area entered")
	door_rigidbody.collision_layer = 0
	door_rigidbody.collision_mask = 0
