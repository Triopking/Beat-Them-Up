extends CharacterBody2D

#double jump
var djump = 1

const SPEED = 20000
const TOPSPEED = 35000
const JUMP_VELOCITY = -550.0

#timers

var cool = true
var just = true
var attack: bool = false
var walking: bool = false
#image
@onready var icon: AnimatedSprite2D = $Icon

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
			icon.play("Jump")
			await icon.animation_finished
			djump = 0

	# Jumping
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		djump = 1
		
		velocity.y = JUMP_VELOCITY * 1
		icon.play("Jump")
		await icon.animation_finished
	
	#changing direction
	var direction = 1
	if Input.is_action_pressed("Left"):
		direction = -1
		walking = true
		icon.flip_h = true
		icon.play("Walk")
	elif Input.is_action_pressed("Right"):
		direction = 1
		walking = true
		icon.flip_h = false
		icon.play("Walk")
	elif attack == true:
		walking = false
	else:
		walking = false
	
	
	# attack

	if Input.is_action_just_pressed("AttackR") and attack == false:
		attack = true
		print("right attack - ")
		$Side2/CollisionShape2D.disabled = false
		
		
		$AnimationPlayer.play("attackR")
		await $AnimationPlayer.animation_finished
		print("attack finished")
		
		attack = false
		
	if Input.is_action_just_pressed("AttackL") and attack == false:
		attack = true
		print("left attack - ")
		$Side2/CollisionShape2D.disabled = false
		
		
		$AnimationPlayer.play("attackL")
		await $AnimationPlayer.animation_finished
		print("attack finished")
		
		attack = false
			
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if  walking == true:
		if Input.is_action_pressed("Sprint"):
			velocity.x = direction * TOPSPEED * delta
		else:
			velocity.x = direction * SPEED * delta
#		velocity.x = move_toward(velocity.x, 0, SPEED)
		print(velocity.x)
	else:
		if attack == false:
			#print("else at bottom is running")
			icon.play("idle")
			velocity.x = 0

	move_and_slide()
