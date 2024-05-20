extends Entity

const SPEED: float = 500.0
const JUMP_VELOCITY: float = -1600.0

@export var attacks: Array[PackedStringArray] = []
@export var attack_weights: Array[PackedInt32Array] = []
@export var health_thresholds: Array[float] = []
@export var player_character: CharacterController = null

var stage = 0
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

var health_bar: TextureProgressBar

func set_state(new_state):
	if curr_state == new_state:
		return

	exit_state(curr_state)
	curr_state = new_state
	enter_state(curr_state)

func _ready():

	# Ensure attack parameters are valid
	print(attacks)
	print(attack_weights)
	assert(attacks.size() == attack_weights.size())
	assert(attacks.size()-1 == health_thresholds.size())
	for i in range(attacks.size()):
		assert(attacks[i].size() == attack_weights[i].size())

	set_state(STATE.IDLE)
	floor_snap_length = 100
	floor_constant_speed = true

	# Set up the health bar
	health_bar = get_node("BossHealthBar/HealthBar")
	health_bar.max_value = max_health
	health_bar.value = current_health

	# wait 2 seconds before starting the boss
	set_physics_process(false)
	await get_tree().create_timer(4.0).timeout
	set_physics_process(true)


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
				if stage < health_thresholds.size() and current_health < max_health * health_thresholds[stage]:
					stage += 1
				attack = Attack.new(attacks[stage][randomChoice(attack_weights[stage])], player_character)
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
				var bullet_rotation:float = curr_time_msec
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

	health_bar.value = current_health

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

