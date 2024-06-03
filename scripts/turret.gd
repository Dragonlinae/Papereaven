extends Sprite2D

const SPEED: float = 500.0
const JUMP_VELOCITY: float = -1600.0

@export var attackName: String = ""
@export var delay: float = 0.0

var attack: Attack


func _ready():
	while true:
		await get_tree().create_timer(delay).timeout

		if attackName != "":
			attack = Attack.new(attackName)
			var bullet = attack.get_bullet(global_position, rad_to_deg(global_rotation), 5.0)
			get_parent().add_child(bullet)
