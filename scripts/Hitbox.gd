class_name Hitbox
extends Area2D

@export var hitbox_state : HitboxState = HitboxState.new()

# Declare Signals
signal triggered(hurtbox : Hurtbox)

# Constructor & Methods
func _init():
	collision_layer = 0
	collision_mask = 0

func _ready():
	area_entered.connect(_on_area_entered)

func enable_hitbox():
	collision_mask = 2
	return

func disable_hitbox():
	collision_mask = 0
	return

func _on_area_entered(hurtbox : Hurtbox):
	if hurtbox == null:
		return
	triggered.emit(hurtbox)