class_name Hitbox
extends Area2D

# Declare Signals
signal triggered(hurtbox : Hurtbox)

# Constructor & Methods
func _init():
	collision_layer = 0
	collision_mask = 2

func _ready():
	if hitbox == null:
		return
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox : Hurtbox):
	triggered.emit(hurtbox)
