extends CharacterBody2D

const SPEED = 1200.0
const JUMP_VELOCITY = -1600.0

var canParry = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		canParry = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("Jump")
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor() and canParry:
		$AnimatedSprite2D.play("Parry")
		canParry = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			$AnimatedSprite2D.play("Walk")
		if direction > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_pressed("ui_down") and is_on_floor():
		$AnimatedSprite2D.play("Block")
	elif not direction and is_on_floor():
		$AnimatedSprite2D.play("Idle")

	floor_snap_length = 100
	floor_constant_speed = true

	move_and_slide()
