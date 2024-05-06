class_name Hitbox
extends Area2D

## (Current unused) The entity responsible for this hitbox.
## If there is no entity responsible, the hitbox is environmental.
## The entity may receive damage when their hitbox hits due to counters.
@export var entity: Entity

## Whether the hitbox is friendly or not.
## Friendly hitboxes deal damage to unfriendly hurtboxes.
@export var friendly: bool

## The amount of damage this hitbox deals when touched.
@export var damage: int

#@export var hitbox_state : HitboxState = HitboxState.new()

# Declare Signals
signal triggered(hurtbox : Hurtbox)

# Constructor & Methods
func _init():
	set_collision_layer(0)
	set_collision_mask(0)
	set_monitoring(false)
	set_monitorable(true)

func _ready():
	#area_entered.connect(_on_area_entered)
	enable_hitbox()

func enable_hitbox():
	set_collision_layer(2 if friendly else 4)

func disable_hitbox():
	set_collision_layer(0)

#func _on_area_entered(hurtbox : Hurtbox):
	#if hurtbox == null:
		#return
	#triggered.emit(hurtbox)
