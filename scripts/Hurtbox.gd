class_name Hurtbox
extends Area2D

## The entity this hurtbox applies damage to.
@export var entity: Entity

## Whether this hurtbox is a friendly target or not.
## Friendly hurtboxes receive damage from unfriendly hitboxes.
@export var friendly: bool

signal triggered(hurtbox: Hitbox)

# Constructor & Methods
func _init():
	set_collision_layer(0)
	stop_listening()
	set_monitoring(true)
	set_monitorable(false)

func _ready():
	start_listening()
	area_entered.connect(_on_hitbox_area_entered)

func start_listening():
	set_collision_mask(4 if friendly else 2)

func stop_listening():
	set_collision_mask(0)

func _on_hitbox_area_entered(hitbox: Hitbox):
	if hitbox is Hitbox:
		print("ow" , hitbox.damage)
		if hitbox.damage > 0 and entity.is_alive():
			entity.take_damage(hitbox.damage)
