extends CharacterBody2D

#raycasts
@onready var left_down: RayCast2D = $LeftDown
@onready var right_down: RayCast2D = $RightDown


#speed and gravity
const SPEED = 10000.0
const JUMP_VELOCITY = -400.0

var direction

func _ready() -> void:
	var rdirection = randi()%2
	if rdirection == 0:
		direction = -1
		left_down.enabled = true
		right_down.enabled = false

	elif rdirection == 1:
		direction = 1
		left_down.enabled = false
		right_down.enabled = true

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#when the raycasts on the left detect something, it would switch directions
	#if not left_down.is_colliding():
	#	direction = 1
	#	left_down.enabled = false
		#right_down.enabled = true
	
	#elif not right_down.is_colliding():
		#direction = -1
		#left_down.enabled = true
		#right_down.enabled = false
	
	#else:
		velocity.x = direction * SPEED * delta
	
	move_and_slide()
