extends Entity

const SPEED: float = 500.0
const JUMP_VELOCITY: float = -1600.0

@export var attacks: Array[String] = []
@export var attack_weights: Array[int] = []
@export var player_character: CharacterController = null

var attack: Attack
var curr_time_msec: int = 0

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

func randomChoice(weights: Array[int]) -> int:
	var total = 0
	for w in weights:
		total += w
	var r = randi() % total
	for i in range(weights.size()):
		r -= weights[i]
		if r < 0:
			return i
	return weights.size() - 1

func update_state(delta):

	curr_time_msec += delta*1000

	match curr_state:
		STATE.IDLE:
			if randf() < 0.01:
				attack = Attack.new(attacks[randomChoice(attack_weights)])
				set_state(STATE.ATTACK)
				modulate = Color(1, 0, 0, 1)
		STATE.ATTACK:
			attack.update_attack_time(delta)
			if attack.attack_finished():
				set_state(STATE.IDLE)
				modulate = Color(1, 1, 1, 1)
		STATE.LEFT:
			set_state(STATE.RIGHT)
		STATE.RIGHT:
			set_state(STATE.LEFT)

	match curr_state:
		STATE.IDLE:
			velocity.x = 0
			pass
		STATE.ATTACK:
			while attack.next_bullet_ready():
				var bullet_rotation:float = deg_to_rad(curr_time_msec / 10 % 360) if attack.atk_name=="star" else deg_to_rad(curr_time_msec/2 % 360) if attack.atk_name=="break" else 0
				var bullet = attack.get_bullet(global_position, bullet_rotation, 5.0)
				get_parent().add_child(bullet)
				attack.next_bullet()
			pass
		STATE.LEFT:
			velocity.x = -SPEED
			pass
		STATE.RIGHT:
			velocity.x = SPEED
			pass

	# move in infinity pattern
	velocity.x = sin(deg_to_rad(curr_time_msec / 10)) * SPEED
	velocity.y = (- cos(deg_to_rad(curr_time_msec / 10)) * cos(deg_to_rad(curr_time_msec / 10)) \
		+ sin(deg_to_rad(curr_time_msec / 10)) * sin(deg_to_rad(curr_time_msec / 10))) * SPEED

	# Get distance to Character
	if player_character:
		var distance = global_position.distance_to(player_character.global_position + Vector2(0, -50))
		if distance > 1000:
			velocity += ((player_character.global_position + Vector2(0, -50) - global_position).normalized() * sqrt((distance-1000)/1000)) * SPEED

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

