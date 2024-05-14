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
@export var can_block: bool = true

#@export var hitbox_state : HitboxState = HitboxState.new()

# Declare Signals
signal hitbox_triggered(hurtbox: Hurtbox, hitbox: Hitbox)

var initial_scale: Vector2
# Constructor & Methods
func _init():
	set_collision_layer(0)
	set_collision_mask(0)
	set_monitoring(true)
	set_monitorable(false)
	initial_scale = scale

func _ready():
	area_entered.connect(_on_area_entered)
	enable_hitbox_damage(damage)

func enable_hitbox():
	set_collision_mask(2 if friendly else 4)
	set_scale(initial_scale)

func disable_hitbox():
	set_collision_mask(0)
	set_scale(Vector2(0, 0))

## Sets damage and enables hitbox
func enable_hitbox_damage(new_damage: int):
	damage = new_damage
	if new_damage > 0: enable_hitbox()
	else: disable_hitbox()

func _on_area_entered(area2d: Area2D):
	var hurtbox: Hurtbox = area2d as Hurtbox
	if hurtbox == null or not hurtbox is Hurtbox:
		return
	
	var processed_damage: int = damage
	var combo_tracker: ComboTracker = get_parent().get_node("ComboTracker") as ComboTracker
	if combo_tracker != null and combo_tracker is ComboTracker:
		processed_damage = int(((combo_tracker.combo_count * 0.10) + 1) * damage)

	print("Ow ", processed_damage)
	if hurtbox.entity.is_alive():
		if can_block == true:
			hurtbox.entity.take_damage(processed_damage)
			hitbox_triggered.emit(hurtbox, self)
		else:
			hurtbox.entity.force_full_damage(processed_damage)
			hitbox_triggered.emit(hurtbox, self)
