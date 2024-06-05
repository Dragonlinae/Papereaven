extends Area2D

const SPEED: float = 500.0
const JUMP_VELOCITY: float = -1600.0

@export var attackName: String = ""
@export var delay: float = 0.0

var attack: Attack
var triggered: bool = false


func _ready():
	
	area_entered.connect(Callable(self, "_on_area_entered"))
	area_exited.connect(Callable(self, "_on_area_exited"))

func _on_area_entered(area):
	if triggered:
		return
	triggered = true

	print(area)

	if area.name == "Player":
		if attackName != "":
			attack = Attack.new(attackName)
			var bullet = attack.get_bullet(global_position, rad_to_deg(global_rotation), 5.0)
			get_parent().add_child(bullet)

func _on_area_exited(area):
	triggered = false
