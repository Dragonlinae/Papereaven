extends Path2D

@export var closed = true
@export var speed = 2.0
@export var speed_scale = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

func _ready():
	print(closed)
	if not closed:
		print(closed)
		animation.play("move")
		animation.speed_scale = speed_scale
		set_physics_process(false)

func _physics_process(delta):
	path.progress += speed
