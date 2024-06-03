extends CanvasLayer

## Entity this healthbar is associated with
@export var entity: Entity

## TextureProgressBar this healthbar controls. Takes `$HealthBar` by default.
@export var progress_bar: TextureProgressBar

# signal callbacks NEED to have the same shape! (same arg count and arg types)
func _update_health(damage_amount: int):
	progress_bar.value = 100.0 * entity.current_health / entity.max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	if progress_bar == null:
		progress_bar = $HealthBar
	assert(entity != null, "In a PlayerHealthBar, an Entity must be assigned to player_health")
	entity.damage_taken.connect(_update_health, 18)
