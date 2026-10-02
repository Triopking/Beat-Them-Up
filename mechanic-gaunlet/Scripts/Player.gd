extends CharacterBody2D


const SPEED = 20000
const TOPSPEED = 35000
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * 1.5
	var direction
	if Input.is_action_pressed("Left"):
		direction = -1
	elif Input.is_action_pressed("Right"):
		direction = 1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		if direction and Input.is_action_pressed("Sprint"):
			velocity.x = direction * TOPSPEED * delta
		else:
			velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
