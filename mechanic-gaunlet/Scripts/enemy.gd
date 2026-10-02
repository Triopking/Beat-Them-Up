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

	elif rdirection == 1:
		direction = 1

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#when the raycasts on the left detect something, it would switch directions
	if not left_down.is_colliding():
		direction = 1
	
	elif not right_down.is_colliding():
		direction = -1
	
	velocity.x = direction * SPEED * delta
	
	move_and_slide()
