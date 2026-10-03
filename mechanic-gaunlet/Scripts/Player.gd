extends CharacterBody2D

#double jump
var djump = 1

const SPEED = 20000
const TOPSPEED = 35000
const JUMP_VELOCITY = -400.0

#timers
@onready var attack_duration: Timer = $AttackDuration
@onready var attack_cooldown: Timer = $AttackCooldown
var cool = true

func _ready() -> void:
	#side 1
	$Side1/CollisionShape2D.disabled = true
	$Side1/CollisionShape2D/Sprite2D.visible = false
	
	#side 2
	$Side2/CollisionShape2D.disabled = true
	$Side2/CollisionShape2D/Sprite2D.visible = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5
		if Input.is_action_just_pressed("Jump") and djump == 1:
			velocity.y = JUMP_VELOCITY * 1.5
			djump = 0

	# Jumping
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		djump = 1
		velocity.y = JUMP_VELOCITY * 1.5
	
	#changing direction
	var direction
	if Input.is_action_pressed("Left"):
		direction = -1
	elif Input.is_action_pressed("Right"):
		direction = 1
	
	# attack
	if cool == true:
		if Input.is_action_pressed("AttackR"):
			$Side1/CollisionShape2D.disabled = false
			$Side1/CollisionShape2D/Sprite2D.visible = true
			attack_duration.start()
		elif Input.is_action_pressed("AttackL"):
			$Side2/CollisionShape2D.disabled = false
			$Side2/CollisionShape2D/Sprite2D.visible = true
			attack_duration.start()
	
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


func _on_attack_duration_timeout() -> void:
	cool = false
	$Side1/CollisionShape2D.disabled = true
	$Side1/CollisionShape2D/Sprite2D.visible = false
	$Side2/CollisionShape2D.disabled = true
	$Side2/CollisionShape2D/Sprite2D.visible = false
	
	attack_cooldown.start()


func _on_attack_cooldown_timeout() -> void:
	cool = true
