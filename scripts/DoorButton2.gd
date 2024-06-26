extends Node2D
class_name DoorButton2

var activated = false
var activated_texture = load("res://assets/ButtonPlaceholder2.png");
var activated_door = load("res://assets/DoorPlaceholderOpened.png");

@export var door_rigidbody: RigidBody2D

func _on_area_2d_area_entered(area):

	if area.get_parent() is CharacterController && !activated:
		activated = true
		$ButtonSprite.texture = activated_texture
		$RigidBody2D/DoorSprite.texture = activated_door
		door_rigidbody.collision_layer = 0
		door_rigidbody.collision_mask = 0
