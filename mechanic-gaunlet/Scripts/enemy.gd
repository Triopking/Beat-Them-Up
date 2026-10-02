extends CharacterBody2D

#raycasts
@onready var left_down: RayCast2D = $LeftDown
@onready var right_down: RayCast2D = $RightDown
#@onready var player: player

#health
var health = 2

#timers
@onready var invincibility: Timer = $Invincibility

#speed and gravity
const SPEED = 10000.0
const JUMP_VELOCITY = -400.0

var hit
var direction

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	var rdirection = randi()%2
	if rdirection == 0:
		direction = -1

	elif rdirection == 1:
		direction = 1

func _physics_process(delta: float) -> void:
	#if enemy has no health left
	if health == 0:
		$CollisionShape2D.disabled = true
	
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#when it is hit
	if hit == true:
		health =- 1
		$AnimationPlayer.play("vulnerable")
		invincibility.start()
	
	#when the raycasts on the left detect something, it would switch directions
	if not left_down.is_colliding():
		direction = 1
	
	elif not right_down.is_colliding():
		direction = -1
	
	#this is for receiving player attacks
	
	velocity.x = direction * SPEED * delta
	
	move_and_slide()


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	
	if area.is_in_group("player_attack"):
		hit = true


func _on_invincibility_timeout() -> void:
	$AnimationPlayer.play("RESET")
	hit = false
	$Area2D/CollisionShape2D.disabled = false
