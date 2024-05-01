extends CharacterBody2D

const SPEED: float = 500.0
const JUMP_VELOCITY: float = -1600.0

@export var attacks: Array = []

var health: int = 50
var attack: Attack

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
			attack = Attack.new(attacks[randi() % attacks.size()])
			set_state(STATE.ATTACK)
		STATE.ATTACK:
			attack.update_attack_time(delta)
			if attack.attack_finished():
				set_state(STATE.IDLE)
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
				var bullet = attack.get_bullet(global_position, deg_to_rad(Time.get_ticks_msec() / 10 % 360))
				get_parent().add_child(bullet)
				attack.next_bullet()
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
