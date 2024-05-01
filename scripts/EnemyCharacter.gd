extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -1600.0

var health = 30

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATE {
	LEFT,
	RIGHT,
	IDLE,
}

var currState = STATE.IDLE

func setState(new_state):
	if currState == new_state:
		return

	exitState(currState)
	currState = new_state
	enterState(currState)

func _ready():
	setState(STATE.IDLE)
	floor_snap_length = 100
	floor_constant_speed = true

func updateState(delta):

	match currState:
		STATE.IDLE:
			setState(STATE.LEFT)
			$AnimatedSprite2D.flip_h = true
		STATE.LEFT:
			for index in get_slide_collision_count():
				var collision = get_slide_collision(index)
				var collider = collision.get_collider()
				if collider.is_in_group("terrain") and collider.global_position.y > global_position.y:
					setState(STATE.RIGHT)
					$AnimatedSprite2D.flip_h = false
		STATE.RIGHT:
			for index in get_slide_collision_count():
				var collision = get_slide_collision(index)
				var collider = collision.get_collider()
				if collider.is_in_group("terrain") and collider.global_position.y > global_position.y:
					setState(STATE.LEFT)
					$AnimatedSprite2D.flip_h = true

	match currState:
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

func enterState(state):
	match state:
		STATE.IDLE:
			$AnimatedSprite2D.play("Idle")
		STATE.LEFT:
			$AnimatedSprite2D.play("Walk")
		STATE.RIGHT:
			$AnimatedSprite2D.play("Walk")

func exitState(state):
	match state:
		STATE.IDLE:
			pass
		STATE.LEFT:
			pass
		STATE.RIGHT:
			pass

func _physics_process(delta):
	updateState(delta)

func takeDamage(damage):
	health -= damage
	if health <= 0:
		set_collision_mask_value(1, false)