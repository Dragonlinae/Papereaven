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

var initial_scale: Vector2
# Constructor & Methods
func _init():
	set_collision_layer(0)
	set_collision_mask(0)
	set_monitoring(false)
	set_monitorable(true)
	initial_scale = scale

func _ready():
	#area_entered.connect(_on_area_entered)
	enable_hitbox()

func enable_hitbox():
	set_collision_layer(2 if friendly else 4)
	set_scale(initial_scale)

func disable_hitbox():
	set_collision_layer(0)
	set_scale(Vector2(0, 0))

## Sets damage and enables hitbox
func enable_hitbox_damage(new_damage: int):
	damage = new_damage
	if new_damage > 0: enable_hitbox()
	else: disable_hitbox()

#func _on_area_entered(hurtbox : Hurtbox):
	#if hurtbox == null:
		#return
	#triggered.emit(hurtbox)
