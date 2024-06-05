extends Node2D

var RedButton = load("res://assets/ButtonPlaceholder.png");
var GreenButton = load("res://assets/ButtonPlaceholder2.png");
var open = false;

# Called when the node enters the scene tree for the first time.
#func _ready():
#	$ButtonSprite.set_texture(RedButton)

func _on_area_2d_area_entered(area):
	print(area.get_parent())
	print("test")
	if area.get_parent() is CharacterController && !open:
		$ButtonSprite.texture = GreenButton
		print("BUTTON")
		open = true 
		remove_child($DoorSprite)
		$DoorSprite.queue_free()
		
