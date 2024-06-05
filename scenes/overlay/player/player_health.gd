extends CanvasLayer

## Entity this healthbar is associated with
@export var entity: Entity

## TextureProgressBar this healthbar controls. Takes `$HealthBar` by default.
@export var progress_bar: TextureProgressBar

# signal callbacks NEED to have the same shape! (same arg count and arg types)
func _update_health():
	progress_bar.value = 100.0 * entity.current_health / entity.max_health

func _ready():
	if progress_bar == null:
		progress_bar = $HealthBar
	assert(entity != null, "In a PlayerHealthBar, an Entity must be assigned to player_health")
	entity.health_changed.connect(_update_health)
