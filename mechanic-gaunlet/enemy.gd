extends CharacterBody2D

#raycasts
@onready var left_down: RayCast2D = $LeftDown
@onready var right_down: RayCast2D = $RightDown
@onready var right_up: RayCast2D = $RightUp
@onready var left_up: RayCast2D = $LeftUp

#speed and gravity
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction

func _ready() -> void:
	var rdirection = randi()%1
	if rdirection == 0:
		direction = -1
	elif rdirection == 1:
		direction = 1

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if left_down.is_colliding() or right_down.is_colliding():
		direction * -1
	else:
		velocity.x = direction * SPEED * delta
	
	move_and_slide()
