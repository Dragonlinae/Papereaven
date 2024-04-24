extends CharacterBody2D

const SPEED = 1200.0
const JUMP_VELOCITY = -1600.0

var canParry = true

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
			pass
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
	# # Add the gravity.
	# if not is_on_floor():
	# 	velocity.y += gravity * delta
	# else:
	# 	canParry = true

	# # Handle jump.
	# if Input.is_action_just_pressed("ui_up") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY
	# 	$AnimatedSprite2D.play("Jump")
	# if Input.is_action_just_pressed("ui_accept") and not is_on_floor() and canParry:
	# 	$AnimatedSprite2D.play("Parry")
	# 	canParry = false

	# # Get the input direction and handle the movement/deceleration.
	# # As good practice, you should replace UI actions with custom gameplay actions.
	# var direction = Input.get_axis("ui_left", "ui_right")
	# if direction:
	# 	velocity.x = direction * SPEED
	# 	if is_on_floor():
	# 		$AnimatedSprite2D.play("Walk")
	# 	if direction > 0:
	# 		$AnimatedSprite2D.flip_h = false
	# 	else:
	# 		$AnimatedSprite2D.flip_h = true
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)

	# if Input.is_action_pressed("ui_down") and is_on_floor():
	# 	$AnimatedSprite2D.play("Block")
	# elif not direction and is_on_floor():
	# 	$AnimatedSprite2D.play("Idle")

	# move_and_slide()
