extends CharacterBody2D

const SPEED: float = 500.0
const JUMP_VELOCITY: float = -1600.0

# Array of resource paths to txt files containing attack names, need to append res://scripts/attacks/ to the beginning of the path and .txt to the end
@export var attacks: Array = []

var health: int = 50
var atk_time: float = 0.0
var atk_total_duration: float = 0.0
var attack: String = ""
var attack_metadata: Array = []
var attack_data: Array = []

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATE {
	LEFT,
	RIGHT,
	IDLE,
	ATTACK,
}

var curr_state: STATE = STATE.IDLE

func set_state(new_state):
	if curr_state == new_state:
		return

	exit_state(curr_state)
	curr_state = new_state
	enter_state(curr_state)

func _ready():
	set_state(STATE.IDLE)
	floor_snap_length = 100
	floor_constant_speed = true

func update_state(delta):

	match curr_state:
		STATE.IDLE:
			attack = attacks[randi() % attacks.size()]
			print(attack)
			attack_metadata = load("res://scripts/attacks/" + attack + ".txt").get_text().split("[Pattern]")
			attack_data = attack_metadata[1].split("\n")
			attack_metadata = attack_metadata[0].split(",")

			atk_time = 0.0
			atk_total_duration = float(attack_metadata[1])

			set_state(STATE.ATTACK)
		STATE.ATTACK:
			if atk_time >= atk_total_duration:
				set_state(STATE.IDLE)
			else:
				atk_time -= delta
		STATE.LEFT:
			set_state(STATE.RIGHT)
		STATE.RIGHT:
			set_state(STATE.LEFT)

	match curr_state:
		STATE.IDLE:
			velocity.x = 0
			pass
		STATE.LEFT:
			velocity.x = -SPEED
			pass
		STATE.RIGHT:
			velocity.x = SPEED
			pass

	velocity.y += gravity * delta

	move_and_slide()

func enter_state(state):
	match state:
		STATE.IDLE:
			pass
		STATE.LEFT:
			pass
		STATE.RIGHT:
			pass

func exit_state(state):
	match state:
		STATE.IDLE:
			pass
		STATE.LEFT:
			pass
		STATE.RIGHT:
			pass

func _physics_process(delta):
	update_state(delta)

func take_damage(damage):
	health -= damage
	if health <= 0:
		set_collision_mask_value(1, false)
