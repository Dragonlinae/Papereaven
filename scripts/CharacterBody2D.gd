extends CharacterBody2D
class_name Player

const SPEED = 1200.0
const JUMP_VELOCITY = -1600.0

var canParry = true

var maxHealth = 30
var health = 30
var iframes: float = 0.0

var HealthBar: ProgressBar

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATE {
	IDLE,
	WALK,
	JUMP,
	PARRY,
	BLOCK,
	FALL
}

var currState = STATE.IDLE

var current_checkpoint: Checkpoint

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
	HealthBar = get_node("CanvasLayer/HealthBar")
	HealthBar.max_value = maxHealth

func updateState(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	var jump = Input.is_action_just_pressed("ui_up")
	var parry = Input.is_action_just_pressed("ui_accept")
	var block = Input.is_action_pressed("ui_down")
	var on_floor = is_on_floor()

	match currState:
		STATE.IDLE:
			if direction:
				setState(STATE.WALK)
			elif jump:
				setState(STATE.JUMP)
			elif block:
				setState(STATE.BLOCK)
		STATE.WALK:
			if not direction:
				setState(STATE.IDLE)
			elif jump:
				setState(STATE.JUMP)
		STATE.JUMP:
			if on_floor:
				setState(STATE.IDLE)
			elif parry:
				setState(STATE.PARRY)
			elif block:
				setState(STATE.BLOCK)
		STATE.PARRY:
			if on_floor:
				setState(STATE.IDLE)
		STATE.BLOCK:
			if not block:
				setState(STATE.IDLE)

	match currState:
		STATE.IDLE:
			velocity.x = 0
		STATE.WALK:
			if direction:
				velocity.x = direction * SPEED
				if direction > 0:
					$AnimatedSprite2D.flip_h = false
				else:
					$AnimatedSprite2D.flip_h = true
			else:
				velocity.x = 0
		STATE.JUMP:
			if jump and on_floor:
				velocity.y = JUMP_VELOCITY
			if direction:
				velocity.x = direction * SPEED
				if direction > 0:
					$AnimatedSprite2D.flip_h = false
				else:
					$AnimatedSprite2D.flip_h = true
			else:
				velocity.x = 0
		STATE.PARRY:
			if parry and not on_floor:
				canParry = false
			if direction:
				velocity.x = direction * SPEED
				if direction > 0:
					$AnimatedSprite2D.flip_h = false
				else:
					$AnimatedSprite2D.flip_h = true
			else:
				velocity.x = 0
		STATE.BLOCK:
			pass

	if not on_floor:
		velocity.y += gravity * delta

	move_and_slide()
	if $EnemyDetector.has_overlapping_bodies() and iframes == 0:
		for body in $EnemyDetector.get_overlapping_bodies():
			if body.is_in_group("enemy"):
				if body.global_position.y < global_position.y + 100:
					set_health(health - 10)
					velocity.y = JUMP_VELOCITY
					iframes = 120.0
					break
				elif velocity.y > 0:
					velocity.y = JUMP_VELOCITY
					body.takeDamage(10)

	if iframes > 0:
		iframes -= min(delta * 60, iframes)

func enterState(state):
	match state:
		STATE.IDLE:
			$AnimatedSprite2D.play("Idle")
		STATE.WALK:
			$AnimatedSprite2D.play("Walk")
		STATE.JUMP:
			$AnimatedSprite2D.play("Jump")
		STATE.PARRY:
			$AnimatedSprite2D.play("Parry")
		STATE.BLOCK:
			$AnimatedSprite2D.play("Block")

func exitState(state):
	match state:
		STATE.IDLE:
			pass
		STATE.WALK:
			pass
		STATE.JUMP:
			pass
		STATE.PARRY:
			pass
		STATE.BLOCK:
			pass

func _physics_process(delta):
	updateState(delta)
	if (position.y > 2000):
		respawn_player()
	
func respawn_player():
	if current_checkpoint != null:
		global_position = current_checkpoint.global_position
		set_health(maxHealth)
		HealthBar.value = maxHealth

func set_health(new_health):
	health = new_health
	HealthBar.value = health
	if health <= 0: # no collision perms when dead
		set_collision_mask_value(1, false)
	else:
		set_collision_mask_value(1, true)
